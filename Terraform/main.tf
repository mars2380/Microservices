resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "EC2" {
	ami = "ami-f90a4880"
	instance_type = "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.default.id}"]

	connection {
    user = "ubuntu"
    }
	
	key_name = "ua15"

	tags {
		Name = "Lab15"
	}

#	provisioner "local-exec" {
#	  command = "ansible-playbook -i /usr/local/bin/terraform-inventory -u ubuntu playbook.yml --private-key=/home/user/.ssh/aws_user.pem -u ubuntu"
#	  }
}

