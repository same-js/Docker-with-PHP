# ベース・イメージの指定
# Dockerfileは、必ず FROM から始らなければいけない（ARGは例外）
FROM php:8.0.1-fpm
# COPY A B　つまり、 B="/" ということ
COPY install-composer.sh /


RUN apt-get update \
  && apt-get install -y wget git unzip \
  # node.js 不要ならコメントアウト
  && : 'Install Node.js' \
  &&  curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y nodejs \
  # mysql
  # && : 'Install PHP Extentions' \
  # && docker-php-ext-install -j$(nproc) pdo_mysql \
  && : 'Install Composer' \
  && chmod 755 /install-composer.sh \
  && /install-composer.sh \
  && mv composer.phar /usr/local/bin/composer
# 【補足】
# RUN コマンド1回の実行につき、イメージレイヤが1つ生成される
# イメージレイヤは、RUN や ADD により、ファイルシステムに加えられた変更の単位
# つまり、可能な限り処理は && や ; で接続し、ワンライナーで実行できるように書くことが推奨されている
