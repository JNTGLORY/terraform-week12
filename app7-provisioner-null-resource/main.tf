resource "aws_iam_group" "group2" {
  name = "DevOps2"
}


resource "aws_instance" "name" {
  ami           = data.aws_ami.ami1.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name

  depends_on = [aws_key_pair.ec2_key, aws_iam_group.group2]

  
}

resource "null_resource" "null" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("week12b.pem")
    host        = aws_instance.name.public_dns
  }
  provisioner "local-exec" {
  when = destroy
    command = "echo hello"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "mkdir jane",
      "pwd",
      "nproc",
    ]
  }
  provisioner "file" {
    source      = "week12b.pem"
    destination = "/tmp/w.pem"
  }
depends_on = [ aws_instance.name ]
}





