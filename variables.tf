variable "aap_controller_password" {
  description = "(Required) Password for the Ansible Automation Platform controller. Should be populated by parent workspace."
  type        = string
  sensitive   = true
}

variable "aap_controller_url" {
  description = "(Required) URL of the Ansible Automation Platform controller (e.g., https://your-aap-url). Should be populated by parent workspace."
  type        = string
}

variable "aap_inventory_id" {
  description = "(Required) The ID of the inventory in AAP. Should be populated by parent workspace."
  type        = string
}

variable "aap_job_template_id" {
  description = "(Required) The ID of the job template in AAP. Should be populated by parent workspace."
  type        = string
}

variable "aap_machine_credential_key_pair_name" {
  description = "(Required) The name of the AWS key pair used for AAP to run playbooks on hosts. Should be populated by parent workspace."
  type        = string
}

variable "name_prefix" {
  description = "(Required) Name prefix for the resources being created by Terraform. Should be populated by parent workspace."
  type        = string
}

variable "public_user_domain" {
  description = "(Required) The public domain name for the user."
  type        = string
}

variable "region" {
  description = "(Required) The AWS region to use for this demo. Should be populated by parent workspace."
  type        = string
}

variable "subnet_ids" {
  description = "(Required) Subnet where the application instance will be launched. Should be populated by parent workspace."
  type        = list(string)
}

variable "tf_value_1" {
  description = "(Required) A value passed to the playbook."
  type        = string
}

variable "vpc_id" {
  description = "(Required) VPC where the application instance will be launched. Should be populated by parent workspace."
  type        = string
}

## Optional variables

variable "aap_controller_username" {
  description = "(Optional) Username for the Ansible Automation Platform controller. Should be populated by parent workspace."
  type        = string
  default     = "admin"
}

variable "aap_insecure_skip_verify" {
  description = "(Optional) Whether to skip SSL certificate validation for the AAP controller."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "(Optional) Specifies the AWS instance type. If you receive an error about availability zones, try changing this value."
  type        = string
  default     = "t3.micro"
}

variable "vault_ssh_ca_public_key" {
  description = "(Optional) The public key contents of the Vault SSH CA for trusted user authentication."
  type        = string
  default     = ""
}