resource "aws_security_group" "dev"
{
  tags
  {
    Name = "${var.pname}-ec2-dev"
  }
  name = "${var.pname}-ec2-dev"
  description = "Created by Shailender Choudhary"

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.cidr}"]

  }
  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
 ingress{
    from_port = 10050
    to_port = 10050
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
