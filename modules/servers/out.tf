output "alb_dns_name"{
	value=aws_lb.LB.dns_name

}
output "link_to_service"{
	value="http://${aws_lb.LB.dns_name}"
}
