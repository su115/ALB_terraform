data "terraform_remote_state" "network"{
	backend = "s3"
	config={
		bucket="terra-state-12-32-40"
		key="stage/vpc/terraform.tfstate"
		region="eu-west-1"
	}
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
