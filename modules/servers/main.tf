#terraform{
#	backend "s3"{
#	bucket="terra-state-12-32-40"
#	key="stage/services/web-cluster/terraform.tfstate"
#	region="eu-west-1"
#	dynamodb_table="terra-lock"
#	encrypt=true
#	}
#}
provider "aws"{
	region="eu-west-1"
	profile="Igor"
}


resource "aws_launch_configuration" "web"{
	image_id="ami-01b6e7f6322673148"#"ami-0a8e758f5e873d1c1"
	instance_type="t2.micro"
	security_groups=[aws_security_group.instance.id]
	lifecycle{
		create_before_destroy=true
	}
	user_data=data.template_file.server.rendered   #"${file("./server.sh")}"
}

resource "aws_lb" "LB"{
	name=var.alb_name
	load_balancer_type="application"
	subnets=local.subnet
	security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
	load_balancer_arn=aws_lb.LB.arn
	port=var.custom_change
	protocol="HTTP"
	default_action{
		type="fixed-response"
		fixed_response{
			content_type="text/plain"
			message_body="404:page not found"
			status_code=404
		}
	}
}

