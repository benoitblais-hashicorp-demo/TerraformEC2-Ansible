output "web_server_url" {
  description = "Access the application at this URL"
  value       = "https://${local.application_domain_name}"
}

output "instance_id" {
  description = "The ID of the application instance"
  value       = aws_instance.application.id
}
