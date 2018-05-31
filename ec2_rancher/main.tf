
resource "aws_security_group" "default" {
  name        = "rancher"
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
  
  # HTTPS access from the VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 500 access from the VPC
  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # 4500 access from the VPC
  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
   # 8080 access from the security group itself
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    self = true
  } 

    # 2376 access from the security group itself
  ingress {
    from_port   = 2376
    to_port     = 2376
    protocol    = "tcp"
    self = true
  }

  # 9345 access from the security group itself
  ingress {
    from_port   = 9345
    to_port     = 9345
    protocol    = "tcp"
    self = true
  }

  # 3306 access from the security group itself
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self = true
  }
  # 2379-2380 access from the security ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # 10250 access from the security group
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # 6643 access from the security group ingress {
    from_port   = 6643
    to_port     = 6643
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ALL IPv4 ICMP
  ingress {
    from_port = 8
    to_port = 0
    protocol = "icmp"
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

resource "aws_key_pair" "auth" {
    key_name   = "Terraform_Key"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
  }

resource "aws_instance" "EC2" {
	ami = "ami-f90a4880"
	instance_type = "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.default.id}"]

	connection {
    user = "ubuntu"
    }

	key_name = "Terraform_Key"

  root_block_device {
      volume_type = "gp2"
      volume_size = 30
  }

tags {
		Name = "Rancher"
	}

  provisioner "local-exec" {
	  command = "ansible-playbook -i hosts ec2_create.yml -e 'ansible_python_interpreter=/usr/bin/python3'"
	  }
}

