output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.sg.id
}

output "load_balancer_dns" {
  description = "Load balancer DNS name"
  value       = aws_lb.lb.dns_name
}

output "autoscaling_group_name" {
  description = "ASG name"
  value       = aws_autoscaling_group.asg.name
}

output "grafana_url" {
  description = "Grafana URL via the Application Load Balancer"
  value       = "http://${aws_lb.lb.dns_name}:3000"
}

output "ssh_public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}
