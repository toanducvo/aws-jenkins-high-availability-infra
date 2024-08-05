output "jenkins_url" {
  description = "URL of the Jenkins application"
  value       = "http://${aws_lb.jenkins_lb.dns_name}"
}

output "jenkins_efs_dns_name" {
  description = "DNS name of the Jenkins EFS"
  value       = aws_efs_file_system.jenkins_efs.dns_name
}