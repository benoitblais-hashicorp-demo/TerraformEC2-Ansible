<!-- BEGIN_TF_DOCS -->
# EC2 provisioned by Terraform and configured with Ansible Automation Platform

This module provisions a secure, internet-facing application stack on AWS and integrates with Ansible Automation Platform (AAP) to automatically run post-provisioning configuration after instance creation and updates.

## Purpose

- Provision AWS infrastructure for a web application endpoint:
  - EC2 instance (RHEL)
  - Security groups
  - Application Load Balancer (ALB)
  - ACM certificate and DNS validation
  - Route53 records for TLS-enabled access
- Register the provisioned host in AAP inventory.
- Trigger an AAP job template from Terraform lifecycle actions.

## Permissions

The identity used by Terraform must have permission to create, read, update, and delete the resources managed by this module.

### AWS provider (`hashicorp/aws`)

At minimum, permissions are required for:

- EC2: AMI lookup, instance, elastic IP, and security group management
- ELBv2: load balancer, target group, listener, and target attachment management
- ACM: certificate request and validation management
- Route53: hosted zone lookup and record management
- Tagging-related API actions for all managed resources

### AAP provider (`ansible/aap`)

At minimum, permissions are required for:

- Read/write access to the specified AAP inventory
- Permission to create/update host entries in that inventory
- Permission to launch and monitor the configured job template

## Authentications

### AWS

- Authenticate the AWS provider using standard AWS credential mechanisms (for example environment variables, shared config/profile, or workload identity).
- The configured identity must be authorized in the target AWS account and region.

### Ansible Automation Platform (AAP)

- Authenticate the AAP provider with:
  - `aap_controller_url`
  - `aap_controller_username`
  - `aap_controller_password`
- Optionally set `aap_insecure_skip_verify` for environments using non-public/self-signed certificates.

## Features

- End-to-end provisioning of networking and compute components required for a public web endpoint
- TLS enablement with ACM and DNS validation records in Route53
- HTTP to HTTPS redirection on the ALB
- Cloud-init bootstrapping support for Vault SSH CA trust material
- Automatic AAP host registration for the provisioned EC2 instance
- Terraform `action_trigger` integration to launch an AAP job on create/update events

## Workflow

1. Terraform discovers a RHEL AMI and provisions the EC2 instance.
2. Terraform allocates and associates an Elastic IP to the instance.
3. Terraform provisions ALB, target group, and listeners.
4. Terraform creates ACM certificate, DNS validation records, and validates the certificate.
5. Terraform creates Route53 application DNS alias to the ALB.
6. Terraform registers the host in AAP inventory.
7. Terraform triggers the configured AAP job template to deploy/configure the application.

## Value Proposition

- Demonstrates infrastructure provisioning and configuration management in one automated workflow.
- Reduces manual handoffs between infrastructure and operations teams.
- Provides a reusable pattern for secure application delivery using Terraform and AAP.

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.5.0)

- <a name="requirement_aap"></a> [aap](#requirement\_aap) (>= 1.1.2)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (6.9.0)

## Modules

No modules.

## Required Inputs

The following input variables are required:

### <a name="input_aap_controller_password"></a> [aap\_controller\_password](#input\_aap\_controller\_password)

Description: (Required) Password for the Ansible Automation Platform controller. Should be populated by parent workspace.

Type: `string`

### <a name="input_aap_controller_url"></a> [aap\_controller\_url](#input\_aap\_controller\_url)

Description: (Required) URL of the Ansible Automation Platform controller (e.g., https://your-aap-url). Should be populated by parent workspace.

Type: `string`

### <a name="input_aap_inventory_id"></a> [aap\_inventory\_id](#input\_aap\_inventory\_id)

Description: (Required) The ID of the inventory in AAP. Should be populated by parent workspace.

Type: `string`

### <a name="input_aap_job_template_id"></a> [aap\_job\_template\_id](#input\_aap\_job\_template\_id)

Description: (Required) The ID of the job template in AAP. Should be populated by parent workspace.

Type: `string`

### <a name="input_aap_machine_credential_key_pair_name"></a> [aap\_machine\_credential\_key\_pair\_name](#input\_aap\_machine\_credential\_key\_pair\_name)

Description: (Required) The name of the AWS key pair used for AAP to run playbooks on hosts. Should be populated by parent workspace.

Type: `string`

### <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix)

Description: (Required) Name prefix for the resources being created by Terraform. Should be populated by parent workspace.

Type: `string`

### <a name="input_public_user_domain"></a> [public\_user\_domain](#input\_public\_user\_domain)

Description: (Required) The public domain name for the user.

Type: `string`

### <a name="input_region"></a> [region](#input\_region)

Description: (Required) The AWS region to use for this demo. Should be populated by parent workspace.

Type: `string`

### <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids)

Description: (Required) Subnet where the application instance will be launched. Should be populated by parent workspace.

Type: `list(string)`

### <a name="input_tf_value_1"></a> [tf\_value\_1](#input\_tf\_value\_1)

Description: (Required) A value passed to the playbook.

Type: `string`

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: (Required) VPC where the application instance will be launched. Should be populated by parent workspace.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_aap_controller_username"></a> [aap\_controller\_username](#input\_aap\_controller\_username)

Description: (Optional) Username for the Ansible Automation Platform controller. Should be populated by parent workspace.

Type: `string`

Default: `"admin"`

### <a name="input_aap_insecure_skip_verify"></a> [aap\_insecure\_skip\_verify](#input\_aap\_insecure\_skip\_verify)

Description: (Optional) Whether to skip SSL certificate validation for the AAP controller.

Type: `bool`

Default: `true`

### <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type)

Description: (Optional) Specifies the AWS instance type. If you receive an error about availability zones, try changing this value.

Type: `string`

Default: `"t3.micro"`

### <a name="input_vault_ssh_ca_public_key"></a> [vault\_ssh\_ca\_public\_key](#input\_vault\_ssh\_ca\_public\_key)

Description: (Optional) The public key contents of the Vault SSH CA for trusted user authentication.

Type: `string`

Default: `""`

## Resources

The following resources are used by this module:

- [aap_host.ec2_host](https://registry.terraform.io/providers/ansible/aap/latest/docs/resources/host) (resource)
- [aws_acm_certificate.application](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/acm_certificate) (resource)
- [aws_acm_certificate_validation.application](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/acm_certificate_validation) (resource)
- [aws_eip.public_ip](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/eip) (resource)
- [aws_eip_association.eip_assoc](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/eip_association) (resource)
- [aws_instance.application](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/instance) (resource)
- [aws_lb.application](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/lb) (resource)
- [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/lb_listener) (resource)
- [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/lb_listener) (resource)
- [aws_lb_target_group.application](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/lb_target_group) (resource)
- [aws_lb_target_group_attachment.application](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/lb_target_group_attachment) (resource)
- [aws_route53_record.application](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/route53_record) (resource)
- [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/route53_record) (resource)
- [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/security_group) (resource)
- [aws_security_group.application_sg](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/resources/security_group) (resource)
- [aws_ami.rhel](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/data-sources/ami) (data source)
- [aws_route53_zone.aws_account](https://registry.terraform.io/providers/hashicorp/aws/6.9.0/docs/data-sources/route53_zone) (data source)

## Outputs

The following outputs are exported:

### <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id)

Description: The ID of the application instance

### <a name="output_web_server_url"></a> [web\_server\_url](#output\_web\_server\_url)

Description: Access the application at this URL

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->