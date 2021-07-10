# Тут інстанси які будуть підніматися балансером 
resource "aws_autoscaling_group" "autoscal"{
	launch_configuration=aws_launch_configuration.web.name
	vpc_zone_identifier=local.subnet
	target_group_arns=[aws_lb_target_group.asg.arn]
	health_check_type="ELB"
	min_size=2
	max_size=10
	tag{
		key="Name"
		value="terra-autoscal-asg"
		propagate_at_launch=true
	}
}


# Група для інстанса
resource "aws_security_group" "instance"{
	name=var.instance_sec_gname
	vpc_id=local.network
	ingress{
		from_port=var.server_port
		to_port=var.server_port
		protocol="tcp"
		cidr_blocks=["0.0.0.0/0"]
	}
	egress{
		from_port=0
		to_port=0
		protocol="tcp"
		cidr_blocks=["0.0.0.0/0"]
	}

}

# Група для балансера
resource "aws_security_group" "alb"{
	name=var.alb_sec_gname
	vpc_id=local.network
	ingress{
		from_port=80
		to_port=80
		protocol="tcp"
		cidr_blocks=["0.0.0.0/0"]
	}
	egress{
		from_port=0
		to_port=0
		protocol="-1"
		cidr_blocks=["0.0.0.0/0"]
	}
}

# Тyт перенаправлення на порт сервера і підняття нових інстансів 
resource "aws_lb_target_group" "asg"{
	name=var.alb_name
	port=var.server_port
	protocol="HTTP"
	vpc_id=local.network
	health_check{
		path="/"
		protocol="HTTP"
		matcher="200"
		interval=15
		timeout=3
		healthy_threshold=2
		unhealthy_threshold=2
	}
}



resource "aws_lb_listener_rule" "asg"{
	listener_arn=aws_lb_listener.http.arn
	priority=100
	condition{
		path_pattern{
			values=["*"]
		}
	}
	action{
		type="forward"
		target_group_arn=aws_lb_target_group.asg.arn
	}
}
