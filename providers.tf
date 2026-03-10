provider "aws" {
  # shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
  region = var.region
  default_tags {
    tags = {
      CreatedBy           = "Terraform"
      terraform_workspace = terraform.workspace
    }
  }
}

provider "aap" {
  host                 = var.aap_controller_url
  username             = var.aap_controller_username
  password             = var.aap_controller_password
  insecure_skip_verify = var.aap_insecure_skip_verify
  timeout              = 120 # Optional: Increase timeout for longer operations
}
