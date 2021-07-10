variable "server_port"{
	description="The port the server will use for HTTP requests."
	type=number
	default=8080 #port on server
}
variable "alb_name" {
	description="The name of ALB (App Load Balancer)"
	type=string
	default="terra-web-alb"
}
variable "instance_sec_gname"{
	description="The name of the security group for ec2 instances"
	type=string
	default="terra-sec-instance"
}
variable "alb_sec_gname"{
	description="The name of the sec group for ALB"
	type=string
	default="terra-sec-alb"
}

locals{
	network=data.terraform_remote_state.network.outputs.network
}
locals{
	subnet-1=data.terraform_remote_state.network.outputs.subnet-1
}
locals{
	subnet-2=data.terraform_remote_state.network.outputs.subnet-2
}
locals{
	subnet=[local.subnet-1,local.subnet-2]
}






variable "custom_change"{
	type=number
#	default=80
}
