

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
	  command = "ansible-playbook -i hosts ec2_rancher.yml -e 'ansible_python_interpreter=/usr/bin/python3' --tags=swap,docker"
	  }
}
