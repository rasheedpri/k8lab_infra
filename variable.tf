variable "ec2_name" {
    default = ["dev_k8_master","dev_k8_worker1","dev_k8_worker2","dev_jen_agent"]
}

variable "ec2_role" {
    default = ["k8_master","k8worker","k8worker","jenkins"]
}