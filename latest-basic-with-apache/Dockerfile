# ベース・イメージの指定
# Dockerfileは、必ず FROM から始らなければいけない（ARGは例外）
FROM php:8-apache
# COPY A B　つまり、 B="/" ということ
COPY install-composer.sh /

RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get install -y wget git unzip vim-gtk3 \
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
  && mv composer.phar /usr/local/bin/composer \
  && a2enmod rewrite
  
  # ドキュメントルートを変更する
  ENV APACHE_DOCUMENT_ROOT='/var/www/public/'
  RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
  
  # mailhog
  RUN wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
    && chmod +x mhsendmail_linux_amd64 \
    && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail
  
  # コンテナログイン時のパスを最後に指定
  WORKDIR  /var/www
  
# 【補足】
# RUN コマンド1回の実行につき、イメージレイヤが1つ生成される
# イメージレイヤは、RUN や ADD により、ファイルシステムに加えられた変更の単位
# つまり、可能な限り処理は && や ; で接続し、ワンライナーで実行できるように書くことが推奨されている
