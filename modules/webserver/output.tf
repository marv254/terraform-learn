output aws_ami{
  value = data.aws_ami.latest-amazon-linux-image
}


 output instance{
   value = aws_instance.myapp-server
 }
 