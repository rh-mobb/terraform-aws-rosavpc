resource "aws_vpc_endpoint" "this" {    
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  lifecycle {
      ignore_changes = [
          route_table_ids,
      ]
  }
}

resource "aws_vpc_endpoint_route_table_association" "this" {
  count = length(var.route_table_ids)
  route_table_id = var.route_table_ids[count.index]
  vpc_endpoint_id = aws_vpc_endpoint.this.id
}