# Expose the DNS name of the Application Load Balancer
# This will be an URL to access the Jenkins application
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.jenkins_lb.dns_name
}