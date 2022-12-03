provider "aws" {
  region = "ap-northeast-1"
}

# デフォルトVPCを取得する
data "aws_vpc" "target_vpc" {
  default = true
}

# デフォルトVPCサブネットを取得する（そしてこれを EC2 と RDS その他 AZ に配置する全てのリソースに適用することで、稼働率を最大にする）
data "aws_subnet" "default_az1" {
  availability_zone = "ap-northeast-1a"
}

# デフォルトのセキュリティグループを取得する
data "aws_security_group" "default_security_group" {
  vpc_id = data.aws_vpc.target_vpc.id
  name = "default"
}

# 暫定的に locals を env として扱う
# EC2 も RDS も1台しか稼働しない前提のため、 AZ は 1a に固定することで稼働率を最大にする
locals {
  app_name = "sample-app"
  my_home_ip_address = ""
  # EC2 --------------------------------------------------------------------------
  ec2_ami = ""
  ec2_instance_type = "t4g.micro"
  ec2_key_pair_name = ""
  ec2_key = "" # 公開鍵（自分のマシンの .pub ファイルの文字列）
  # RDS --------------------------------------------------------------------------
  rds_name = "database-01"
  rds_engine = "mysql"
  rds_db_name = ""
  rds_engine_version = "8.0"
  rds_instance_type = "db.t4g.micro" # 最も安いのは mysql 8.0 なら db.t4g.micro / 5.7 なら db.t3.micro となる
  rds_username = "root"
  rds_database_root_password = "xxxxxxxx" # パスワードの管理方法は検討すること
  rds_multi_az = false
  # VPC --------------------------------------------------------------------------
  default_vpc = data.aws_vpc.target_vpc
  default_subnet = data.aws_subnet.default_az1
  default_security_group = data.aws_security_group.default_security_group
}

