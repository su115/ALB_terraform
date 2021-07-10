output "network"{
	value=aws_vpc.web.id
}
output "subnet-1"{
	value=aws_subnet.webs-1.id
}
output "subnet-2"{
	value=aws_subnet.webs-2.id
}
