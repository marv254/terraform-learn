
  resource "aws_default_security_group" "myapp-default-sg" {
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image"{
  most_recent = true
  owners = ["amazon"]
  filter{
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_key_pair" "myapp-key" {
  key_name           = "myapp-server-key"
  public_key = "${file(var.public_key_location)}"

}

 resource "aws_instance" "myapp-server"{
 ami = data.aws_ami.latest-amazon-linux-image.id
 instance_type = var.instance_type

 subnet_id = var.subnet_id
 vpc_security_group_ids = [aws_default_security_group.myapp-default-sg.id]
 availability_zone=var.avail_zone
 associate_public_ip_address = true
 key_name = aws_key_pair.myapp-key.key_name

user_data = file("entry-script.sh")

 tags = {
  Name = "${var.env_prefix}-myapp-server"
 }

 }