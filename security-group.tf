data "aws_vpc" "main" {
  default = true
}

locals {
  ingress_rules = [{
    port        = 80
    description = "Port 80"
    },
    {
      port        = 22
      description = "Port 22"
  }]
}
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
     
    }
  }
  /*
  ingress {
    description = "http Port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh Port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
*/
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "allow_web"
  }
}