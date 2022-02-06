output "instance_id" {

description =  "ID of the EC2 isntance"
value = aws_instance.app_server.id


}

output "instance_ip" {

description = "public ip of EC2 instance"
value = aws_instance.app_server.public_ip


}
