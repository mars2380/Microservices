resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.EC2.id}"
  allocation_id = "${aws_eip.EIP.id}"
}

resource "aws_key_pair" "auth" {
    key_name   = "Terraform_Key"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
  }

resource "aws_instance" "EC2" {
	ami = "ami-f90a4880"
	instance_type = "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.default.id}"]
  vpc_security_group_ids = ["${aws_security_group.kubernetes.id}"]

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
	  command = "ansible-playbook -i hosts ec2_rancher.yml -e 'ansible_python_interpreter=/usr/bin/python3' --tags=ec2_instance,docker"
	  }
}

resource "aws_eip" "EIP" {
  vpc = true
}

output "ip" {
  value = "${aws_eip.EIP.public_ip}"
}