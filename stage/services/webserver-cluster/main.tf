terraform{
	backend "s3"{
	bucket="terra-state-12-32-40"
	key="stage/services/web-cluster/terraform.tfstate"
	region="eu-west-1"
	dynamodb_table="terra-lock"
	encrypt=true
	}
}
#provider "aws"{
#	regioin="eu-west-1"
#}
module "servers"{
	source="../../../modules/servers/"
	custom_change=81
}
