# Security Groups --------------------------------------------------------------------------
# refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# ひとつのセキュリティグループ内に、複数のインバウンドルールを指定することができない（terraformの限界）
# cider_block（≒IP） or prefix_list_id は複数指定できる
resource "aws_security_group" "http_from_cloudfront" {
    name   = "http-from-cloudfront"
    vpc_id = local.default_vpc.id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        prefix_list_ids = ["pl-58a04531"] // cloudfront facing
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "db_from_my_home" {
    name   = "db-from-my-home"
    vpc_id = local.default_vpc.id
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = [
            local.my_home_ip_address
        ]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ssh_from_my_home" {
    name   = "ssh_from_my_home"
    vpc_id = local.default_vpc.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [
            local.my_home_ip_address
        ] // my home IP address
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# Elastic IP (EIP) -----------------------------------------------------------------------
# refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "eip_for_ec2" {
  vpc      = true
}
