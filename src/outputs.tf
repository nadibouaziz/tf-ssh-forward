output "public_ip" {
  value = aws_instance.forward_ssh.public_ip
}

output "ami_id" {
  value = data.aws_ami.amzn2.id
}

output "ami_name" {
  value = data.aws_ami.amzn2.name
}