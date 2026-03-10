data "aws_ami" "rhel" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9.3*_HVM-*x86_64*GP3"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # RedHat
}

locals {
  ami_id = data.aws_ami.rhel.id

  cloud_init_config = templatefile("${path.module}/cloud-init.yaml", {
    vault_ssh_ca_public_key = var.vault_ssh_ca_public_key != "" ? base64encode(var.vault_ssh_ca_public_key) : "no_public_key"
  })
}

# Define an action to launch the AAP job
action "aap_job_launch" "deploy_app" {
  config {
    job_template_id                     = var.aap_job_template_id
    inventory_id                        = var.aap_inventory_id
    wait_for_completion                 = true
    wait_for_completion_timeout_seconds = 300
    extra_vars = jsonencode({
      tf_value_1 = var.tf_value_1
    })
  }
}

resource "aws_instance" "application" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  key_name                    = var.aap_machine_credential_key_pair_name
  associate_public_ip_address = true
  subnet_id                   = var.subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.application_sg.id]
  user_data                   = base64encode(local.cloud_init_config)

  tags = {
    App  = var.name_prefix
    Name = "${var.name_prefix}-application"
  }

  lifecycle {
    action_trigger {
      events  = [after_create, after_update]
      actions = [action.aap_job_launch.deploy_app]
    }
  }
}

resource "aws_eip" "public_ip" {
  instance = aws_instance.application.id
  domain   = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.application.id
  allocation_id = aws_eip.public_ip.id
}

# Add the EC2 instance as a host to the AAP inventory
resource "aap_host" "ec2_host" {
  name         = "Application Host"
  description  = "EC2 instance ${aws_eip.public_ip.public_ip}, managed by Terraform"
  inventory_id = var.aap_inventory_id
  enabled      = true
  variables = jsonencode({
    ansible_host = aws_eip.public_ip.public_ip
  })
}
