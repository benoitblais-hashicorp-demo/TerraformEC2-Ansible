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
