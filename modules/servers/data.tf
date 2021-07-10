data "terraform_remote_state" "network"{
	backend = "s3"
	config={
		bucket="terra-state-12-32-40"
		key="stage/vpc/terraform.tfstate"
		region="eu-west-1"
	}
}

data "terraform_remote_state" "db"{
	backend="s3"
	config={
		bucket="terra-state-12-32-40"
		key="stage/data-storage/mysql/terraform.tfstate"
		region="eu-west-1"
	}
}

data "template_file" "server"{
	template=file("${path.module}/server.sh")
	vars={
		server_port=var.server_port
		db_address=data.terraform_remote_state.db.outputs.address
		db_port=data.terraform_remote_state.db.outputs.port
		db_username=local.secret.username	#data.aws_secretsmanager_secret.db.username
		db_password=local.secret.password	#data.aws_secretsmanager_secret.db.password
		db_name=local.secret.name
	}
}

# aws_secretsmanager_secret
data "aws_secretsmanager_secret_version" "db"{
	secret_id="myis"
	#arn="arn:aws:secretsmanager:eu-west-1:023742327175:secret:myis-fqWlVw"
	#name="myis"
}

# make loacals
locals{
	secret=jsondecode(
		data.aws_secretsmanager_secret_version.db.secret_string
	)
}

