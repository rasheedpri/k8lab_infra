provider "aws" {
  region     = "us-east-1"
}


# Generate ansible inventory file

resource "local_file" "ansible_inventory" {
    count = 4
    content     =  templatefile(
                    "${path.cwd}/ansible/hosts.tftpl", {
                     hostname= "worker", workernode_ip =  "${element(data.aws_network_interface.eni.private_ip, count.index)}"                   
                     })
    filename    = "${path.cwd}/hosts"
    depends_on = [aws_instance.ec2,]
}



