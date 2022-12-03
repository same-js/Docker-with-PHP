# 自分のキーペアをインポート
resource "aws_key_pair" "ed25519_key" {
  key_name   = local.ec2_key_pair_name
  public_key = local.ec2_key
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2_for_production.id
  allocation_id = aws_eip.eip_for_ec2.id
}

# user_data に、 PHP, Nginx, Node.js, その他必要なモジュールをインストールするコマンドを書いていく
resource "aws_instance" "ec2_for_production" {
  ami                    = local.ec2_ami
  instance_type          = local.ec2_instance_type
  subnet_id              = local.default_subnet.id
  vpc_security_group_ids = [
    local.default_security_group.id,
    aws_security_group.http_from_cloudfront.id,
    aws_security_group.ssh_from_my_home.id
  ]
  key_name               = aws_key_pair.ed25519_key.key_name
  root_block_device {
        # device_name = "${var.ebs_root_device_name}"
        volume_type = "gp3"
        volume_size = "20"
        # delete_on_termination = "${var.ebs_root_delete_on_termination}"
    }
  disable_api_stop = true # 停止保護
  disable_api_termination = true # 終了保護
  instance_initiated_shutdown_behavior = "stop" # シャットダウン時の動作：停止（stop）にしておくべき
  credit_specification {
    cpu_credits = "standard" # クレジット仕様 個人開発なら unlimited は危険
  } 
  ebs_optimized = true # ネットワークトラフィックをEBS専用に用意するか（少額の料金がかかる）
  
  capacity_reservation_specification {
   capacity_reservation_preference = "none" # キャパシティーの予約（少額の料金がかかる、常に起動しっぱなしのWeb Serverでは不要と判断） 
  }
  tenancy = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags = "enabled"
  }
  user_data_replace_on_change = true # 以下の user_data に更新があった時、 destroy & add を行う
  user_data = <<EOF
#!/bin/bash

yum update -y

# Set Time Zone --------------------------------------------------------
timedatectl set-timezone Asia/Tokyo

# Make swap ------------------------------------------------------------
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=2048
chmod 600 /var/swap.1
mkswap /var/swap.1
swapon /var/swap.1
echo "/var/swap.1 swap swap defaults 0 0" >> /etc/fstab

# Install nginx --------------------------------------------------------
amazon-linux-extras install nginx1 -y
systemctl enable nginx.service

EOF
}
