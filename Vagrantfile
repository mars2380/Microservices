$script = <<-SCRIPT
sudo apt-get update
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible -y
SCRIPT

Vagrant.configure("2") do |config|

  config.vm.define "k8s" do |k8s|

    k8s.vm.box = "ubuntu/xenial64"

    k8s.vm.network "public_network"

    ### Install Ansible and deploy playbook ###
    
    k8s.vm.provision "shell", inline: $script

    config.vm.provision :ansible do |ansible|
        ansible.playbook = "vagrant_k8s.yml"
      end
    k8s.vm.provision "shell", inline: "ip a | grep inet"
  end

  config.vm.define "jen" do |jen|
  
    jen.vm.box = "ubuntu/xenial64"

    jen.vm.network "public_network"

    ### Install Ansible and deploy playbook ###
    
    jen.vm.provision "shell", inline: $script

    # jen.vm.provision :ansible do |ansible|
    #     ansible.playbook = "vagrant_k8s.yml"
    #   end
    jen.vm.provision "shell", inline: "ip a | grep inet"
  end
end
