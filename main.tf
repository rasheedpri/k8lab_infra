provider "aws" {
  region     = "us-east-1"
}


# Generate ansible inventory file

resource "local_file" "ansible_inventory" {
    content     =  templatefile(
                    "${path.cwd}/ansible/hosts.tftpl", {
                     hostname= "worker", workernode_ip =  "${data.aws_network_interface.k8worker.*.private_ip}",
                     k8master_ip = "${data.aws_network_interface.k8master.*.private_ip}"                
                     })
    filename    = "${path.cwd}/hosts"
    depends_on = [aws_instance.ec2,]
}
