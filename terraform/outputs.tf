output "bastion_public_ip" {
  description = "Public IP của máy Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "private_server_ip" {
  description = "Private IP nội bộ của Private Server"
  value       = aws_instance.private.private_ip
}

output "ssh_connect_command" {
  description = "Lệnh SSH trực tiếp vào Bastion Host"
  value       = "ssh -A ec2-user@${aws_instance.bastion.public_ip}"
}