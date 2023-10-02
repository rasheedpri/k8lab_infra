provider "aws" {
  region     = "us-east-1"
}


# Generate ansible inventory file

resource "local_file" "ansible_inventory" {
    content     =  templatefile(
                    "${path.cwd}/ansible/hosts.tftpl", {
                     hostname= "worker", workernode_ip =  "${data.aws_network_interface.k8worker.*.private_ip}"                
                     })
    filename    = "${path.cwd}/hosts"
    depends_on = [aws_instance.ec2,]
}

# resource "local_file" "ansible_inventory" {
#     content     =  templatefile(
#                     "${path.cwd}/hosts.tftpl", {
#                      hostname = "AZUVNLABFGT00", fortigate_ip =  "${data.azurerm_public_ip.PublicIP.*.ip_address}",                   
#                      })
#     filename    = "${path.cwd}/hosts.ini"
#     depends_on = [time_sleep.wait_180_seconds,azurerm_virtual_machine.fortigate_vm,]
# }