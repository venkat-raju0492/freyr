data "aws_availability_zones" "available" {
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support   = var.enable_dns_support
    instance_tenancy = "default"
	
   tags = merge(var.common_tags, {
    "Name" = "${var.project}-vpc-${var.environment}"
  })
}

resource "aws_internet_gateway" "igw" {
    vpc_id=aws_vpc.vpc.id

    tags = merge(var.common_tags, {
    "Name" = "${var.project}-${var.environment}-igw"
  })
}

resource "aws_subnet" "public_subnet" {
    count = var.public_subnet_count
    cidr_block = "${element(var.public_subnet_cidr,count.index)}"
    vpc_id = aws_vpc.vpc.id
    availability_zone="${element(data.aws_availability_zones.available.names,count.index)}"
    map_public_ip_on_launch= var.public_ip_on_launch
	
    tags = merge(var.common_tags, {
    "Name" = "${var.project}-${var.environment}-public-subnet-${count.index+1}"
  }) 
}

resource "aws_subnet" "private_subnet" {
    count = var.private_subnet_count
    cidr_block = "${element(var.private_subnet_cidr,count.index)}"
    vpc_id = aws_vpc.vpc.id
    availability_zone="${element(data.aws_availability_zones.available.names,count.index)}"
    map_public_ip_on_launch = "false"

    tags = merge(var.common_tags, {
    "Name" = "${var.project}-${var.environment}-private-subnet-${count.index+1}"
  })
}

resource "aws_eip" "nat" {
    vpc = true
	
    tags = merge(var.common_tags, {
    "Name" = "${var.project}-${var.environment}-nat-ip"
  })
  
}

resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.nat.id
    subnet_id = "${element(concat(aws_subnet.public_subnet.*.id, [""]), 0)}"
    depends_on = [aws_internet_gateway.igw]

    tags = merge(var.common_tags, {
    "Name" = "${var.project}-${var.environment}-nat-gtw"
  }) 
}
