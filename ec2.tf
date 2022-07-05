# resource block
resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.al2.id
  instance_type   = "t2.small"
  security_groups = [aws_security_group.web_traffic.name]
  key_name        = "mykey"


  provisioner "remote-exec"  {
    inline  = [
      "sudo yum upgrade -y",
      "sudo yum install -y wget git" ,
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum install -y jenkins java-11-amazon-corretto",
      "sudo amazon-linux-extras install -y docker",
      "sudo systemctl enable docker.service",
      "sudo usermod -a -G docker jenkins",
      "sudo systemctl restart docker.service",
      "sudo service jenkins start",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
      ]
   }
 connection {
    type         = "ssh"
    host         = self.public_ip
    user         = "ec2-user"
    private_key  = file("mykey.pem" )
   }
  tags  = {
    "Name"      = "Jenkins"
      }
 }