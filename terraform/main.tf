provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "udpserver" {
  ami           = "ami-97785bed"
  instance_type = "t1.micro"
  key_name      = "bmetcalf"

  connection {
    user = "ec2-user"
    host = "${self.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo docker pull brandonmetcalf/udpserver:latest",
      "sudo docker run -d -p 5000:5000/udp -e HOSTNAME=`hostname` --log-opt tag=\"{{.ImageName}}/{{.Name}}/{{.ID}}\" --log-driver=syslog brandonmetcalf/udpserver:v4"
    ]
  }
}
