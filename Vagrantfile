cumulus_box = "CumulusCommunity/cumulus-vx"
linux_box = "bento/ubuntu-18.04"
# plane_count must be equal spine_count or else           
plane_count = 4
spine_count = 4
pod_count = 2

Vagrant.configure(2) do |config|
  # creating fabric planes
  (1..plane_count).each do |i|
    config.vm.define "plane#{i}" do |node|
      config.vm.provider "virtualbox" do |node|
        node.name = "plane#{i}"
        node.memory = 2048
      end
      node.vm.box = cumulus_box
      node.vm.box_download_insecure = true
      (1..pod_count).each do |j|
        node.vm.network "private_network", virtualbox__intnet: "plane#{i}_swp#{j}", auto_config: false
      end
      node.vm.hostname = "plane#{i}"
      node.vm.provision "shell", path: "provisioner.sh", args: "plane#{i}"
    end
  end
  
  # creating pods
  (1..pod_count).each do |k|
    (1..spine_count).each do |m|
      config.vm.define "p#{k}s#{m}" do |node|
        config.vm.provider "virtualbox" do |node|
	  node.name = "p#{k}s#{m}"
	  node.memory = 2048
        end
	node.vm.box = cumulus_box
	node.vm.box_download_insecure = true
	node.vm.network "private_network", virtualbox__intnet: "plane#{m}_swp#{k}", auto_config: false
	node.vm.network "private_network", virtualbox__intnet: "p#{k}s#{m}_tor1", auto_config: false
	node.vm.hostname = "p#{k}s#{m}"
	node.vm.provision "shell", path: "provisioner.sh", args: "p#{k}s#{m}"	  
      end
    end
  end

  # creating TORs and connected Linux server, one per pod
  (1..pod_count).each do |n|
    config.vm.define "p#{n}tor1" do |node|
      config.vm.provider "virtualbox" do |node|
        node.name = "p#{n}tor1"
        node.memory = 2048
      end
      node.vm.box = cumulus_box
      node.vm.box_download_insecure = true
      (1..spine_count).each do |l|
         node.vm.network "private_network", virtualbox__intnet: "p#{n}s#{l}_tor1", auto_config: false
      end
      node.vm.network "private_network", virtualbox__intnet: "p#{n}_tor1", auto_config: false
      node.vm.hostname = "p#{n}tor1"
      node.vm.provision "shell", path: "provisioner.sh", args: "p#{n}tor1"
    end
    config.vm.define "linux#{n}" do |node2|
      config.vm.provider "virtualbox" do |node2|
        node2.name = "linux#{n}"
        node2.memory = 2048
      end
      node2.vm.box = linux_box
      node2.vm.box_download_insecure = true
      node2.vm.network "private_network", virtualbox__intnet: "p#{n}_tor1", auto_config: false
      node2.vm.hostname = "linux#{n}"
      node2.vm.provision "shell", path: "provisioner.sh", args: "linux#{n}"
    end
  end
  
end
