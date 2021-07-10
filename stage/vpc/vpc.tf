terraform{
	backend "s3"{
	bucket="terra-state-12-32-40"
	key="stage/vpc/terraform.tfstate"
	region="eu-west-1"
	dynamodb_table="terra-lock"
	encrypt=true
	}
}

# Provider
provider "aws"{
	profile="Igor"
	region="eu-west-1"
}

# VPC
resource "aws_vpc" "web"{
	cidr_block = "10.0.0.0/16"
	instance_tenancy="default"
	


	#!!! test DB!!!
	enable_dns_support=true
	enable_dns_hostnames=true

	tags={
		Name="web"
	}
}

# Subnet 2
resource "aws_subnet" "webs-2"{
	availability_zone = data.aws_availability_zones.available.names[0]
	vpc_id=aws_vpc.web.id
	cidr_block="10.0.128.0/18"


	#!!!test DB!!!
#	map_public_ip_on_launch=true

	tags = {
		Name="Web-cluster"
	}
}

################ NAT ####################
# EIP
#resource "aws_eip" "eip"{
#	vpc=true
#}

# NAT GATEWAY to sub 1
#resource "aws_nat_gateway" "ngw1"{
#	allocation_id=aws_eip.eip.id
#	subnet_id=aws_subnet.webs-1.id
#	tags={
#		Name="Nat Gateway1"
#	}
#}

# NAT GATEWAY to sub 2
#########################################
#resource "aws_nat_gateway" "ngw2"{
#	allocation_id=aws_eip.eip.id
#	subnet_id=aws_subnet.webs-2.id
#	tags={
#		Name="Nat Gateway2"
#	}
#}

# Subnet 1
resource "aws_subnet" "webs-1"{
	availability_zone = data.aws_availability_zones.available.names[1]
	vpc_id=aws_vpc.web.id	

	#!!!test DB!!!
#	map_public_ip_on_launch=true

	cidr_block="10.0.0.0/18"
	tags = {
		Name="Web-cluster"
	}
}


# INTERNET GATEWAY
resource "aws_internet_gateway" "gt"{
	vpc_id=aws_vpc.web.id
	tags={
		Name="LB web gateway"
	}
}

# ROUTE TABLE
resource "aws_route_table" "art"{
	vpc_id=aws_vpc.web.id
	route{
		cidr_block="0.0.0.0/0"
		gateway_id=aws_internet_gateway.gt.id
	}
}

# ROUTE TABLE ASSOCIATION to webs-1
resource "aws_route_table_association" "rta1"{
	subnet_id=aws_subnet.webs-1.id
	route_table_id=aws_route_table.art.id
}

# ROUTE TABLE ASSOCIATION to webs-2
resource "aws_route_table_association" "rta2"{
	subnet_id=aws_subnet.webs-2.id
	route_table_id=aws_route_table.art.id
}

# Availability zone
data "aws_availability_zones" "available" {
  state = "available"
}


