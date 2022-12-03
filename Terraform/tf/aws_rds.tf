# RDS ---------------------------------------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "mysql_01" {
  availability_zone = local.default_subnet.availability_zone
  allocated_storage    = 20 # ディスク容量の最低値
  max_allocated_storage = 30 # auto scalling で許容するディスク容量の最大値
  # identifier_prefix    = local.rds_name # RDS名 こちらを使用する場合は timestamps が RDS名の後ろに付与される
  identifier           = local.rds_name # RDS名
  db_name              = local.rds_db_name # 最初の1個目のDB名
  engine               = local.rds_engine
  engine_version       = local.rds_engine_version
  instance_class       = local.rds_instance_type
  username             = local.rds_username # for master user
  password             = local.database_root_password # formaster user
  parameter_group_name = aws_db_parameter_group.mysql_settings_01.name
  skip_final_snapshot  = true
  multi_az             = local.rds_multi_az # 料金を最低に抑えるためには false とする
  auto_minor_version_upgrade = true # 自動でマイナーバージョンアップを許す
  publicly_accessible = true # VPC外（具体的には My MacBook など）からでもSSH接続できるようにするか
  vpc_security_group_ids = [
    local.default_security_group.id,
    aws_security_group.db_from_my_home.id
  ]
  apply_immediately   = false # 即時反映が必要な場合のみ true にし、普段は false にしておくべき
}


resource "aws_db_parameter_group" "mysql_settings_01" {
  name   = "${local.app_name}-database-cluster-parameter-group"
  family = "${local.engine}${local.engine_version}"

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}
