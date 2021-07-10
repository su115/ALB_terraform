terraform{
	backend "s3"{
	bucket="terra-state-12-32-40"
	key="stage/data-storage/mysql/terraform.tfstate"
	region="eu-west-1"
	dynamodb_table="terra-lock"
	encrypt=true
	}
}

provider "aws"{
	profile="Igor"
	region="eu-west-1"
}

# DB
resource "aws_db_instance" "example"{
	identifier_prefix="terraform-up-and-running"
	engine="mysql"
	allocated_storage=5
	port=var.db_port

	#Щоб можна видалити
	skip_final_snapshot=true

	db_subnet_group_name=aws_db_subnet_group.sub_grp.id
	
	parameter_group_name=aws_db_parameter_group.defa.name
	publicly_accessible=true
	vpc_security_group_ids=[aws_security_group.db.id]
	
	instance_class="db.t2.micro"
	name=local.secret.name	#db name
	username=local.secret.username	#data.aws_secretsmanager_secret.db.username
	password=local.secret.password	#data.aws_secretsmanager_secret.db.password
}

resource "aws_db_parameter_group" "defa" {
  name   = "rds-pg"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}


# DB SUBNET GROUP
resource "aws_db_subnet_group" "sub_grp"{
	name="db_subnet_grp"
	tags={	Name="mySubnets"	}
	subnet_ids=local.subnet
}

# DB SECURITY GROUP
resource "aws_security_group" "db"{
	name="db_sec_grp"
	vpc_id=local.network
	ingress{
		from_port=var.db_port
		to_port=var.db_port
		protocol="tcp"
		cidr_blocks=["0.0.0.0/0"]
		}
	egress{
		from_port=0
		to_port=0
		protocol=-1
		cidr_blocks=["0.0.0.0/0"]
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

