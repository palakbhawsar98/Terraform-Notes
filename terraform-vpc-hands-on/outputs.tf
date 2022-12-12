output "public_ip" {
  value = aws_instance.my_app_server.*.public_ip

}

output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true

}