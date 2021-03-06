$ansible_script = <<-SCRIPT
sudo apt-get update
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible -y
SCRIPT

$docker_script = <<-SCRIPT
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce -y
SCRIPT

$run_docker_script = <<-SCRIPT
if [[ $(sudo docker ps -a | grep myjenkins | awk '{print $NF}') ]]; then
    sudo docker start myjenkins;
else
    docker run --name myjenkins \
    -p 8080:8080 -p 50000:50000 \
    -v /var/jenkins_home:/root/.jenkins \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(which docker):/usr/bin/docker \
    --privileged \
    jenkins:latest;
fi
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.define "k8s" do |k8s|

    k8s.vm.box = "ubuntu/xenial64"

    k8s.vm.hostname = "kubernetes"

    k8s.vm.network "public_network", bridge: "eth0"

    k8s.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 2048]
#     v.customize ["modifyvm", :id, "--name", "Rancher"]
    end

    ### Install Ansible and deploy playbook ###

    k8s.vm.provision "shell", inline: $ansible_script

    k8s.vm.provision :ansible do |ansible|
        ansible.playbook = "vagrant_k8s.yml"
      end
    k8s.vm.provision "shell", inline: "ip a | grep inet"
  end

  config.vm.define "jen" do |jen|

    jen.vm.box = "ubuntu/xenial64"

    jen.vm.hostname = "jenkins"

    jen.vm.network "public_network", bridge: "eth0"

    ### Install Docker and Jenkins ###

    jen.vm.provision "shell", inline: $docker_script

#    jen.vm.provision "shell", inline: "docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home jenkins"

#   jen.vm.provision "shell", inline: "if [[ $(sudo docker ps -a | grep myjenkins | awk '{print $NF}') ]]; then sudo docker start myjenkins; else docker run --name myjenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home jenkins; fi"
    jen.vm.provision "shell", inline: $run_docker_script


    jen.vm.provision "shell", inline: "ip a | grep inet"
  end

   config.vm.define "rancher" do |rancher|

    rancher.vm.box = "ubuntu/xenial64"

    rancher.vm.hostname = "rancher"

    rancher.vm.network "public_network", bridge: "eth0"

    rancher.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 4096]
#     v.customize ["modifyvm", :id, "--name", "Rancher"]
    end

    ### Install Ansible and Rancher ###

    rancher.vm.provision "shell", inline: $ansible_script

    rancher.vm.provision :ansible do |ansible|
        ansible.playbook = "vagrant_rancher.yml"
      end

    rancher.vm.provision "shell", inline: "ip a | grep inet"
  end
end
