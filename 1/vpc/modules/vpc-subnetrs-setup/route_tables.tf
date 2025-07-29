resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = merge(var.common_tags, {
    "Name" = "${var.project}-${var.environment}-rtb-public"
  })
}
resource "aws_route_table_association" "public_rtb_ass" {
    count = var.route_ass_count
    subnet_id = "${element(concat(aws_subnet.public_subnet.*.id, [""], []), count.index)}"
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw.id
    }

  tags = merge(var.common_tags, {
    "Name" = "${var.project}-${var.environment}-rtb-private"
  })
}

resource "aws_route_table_association" "private_rtb_ass" {
    count = var.route_ass_count
    subnet_id = "${element(concat(aws_subnet.private_subnet.*.id, [""], []), count.index)}"
    route_table_id = aws_route_table.private_route_table.id
}



