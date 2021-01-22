# PHP8 with Docker
PHP8.0 + MySQL8.0 で遊ぶためのシンプルなDocker環境構築セット。

## Dockerコンテナのビルド手順

### コンテナ起動
初回実行時のみ、まあまあ時間がかかる。5分ぐらい。
```sh
cd path/to/
docker-compose up -d
```

### コンテナログイン（Webサーバ）

```sh
$ docker-compose exec www bash # Webサーバのコンテナにログイン
```

### コンテナログイン（DBサーバ）

```sh
$ docker-compose exec mysql bash # DBサーバのコンテナにログイン
$ mysql -u docker -p
Enter password: # 「docker」 を入力
> use test_database;
```

### 動作確認
```sh
$ cd path/to/www/
$ docker-compose exec www bash # コンテナに入る
$ echo "<?php phpinfo(); ?>" >> index.php
$ php -S 0.0.0.0:8000 -t ./
```

上記コマンドを最後まで実行後、 `http://localhost` にアクセスすると、3行目で入力した内容が表示される。

## Laravelを使用する場合
### .gitkeepファイルを削除
Laravelは `www` ディレクトリが空でないとインストールできない。
そのため、 `www` ディレクトリ内にある `.gitkeep` ファイルを削除する。

```sh
$ cd path/to/www/
$ rm .gitkeep
```

### インストールコマンド
下記のコマンドで、Laravelの6.x（LTS最新）がインストールされる。

```sh
$ cd path/to/www/
$ docker-compose exec www bash # コンテナに入る
$ composer create-project --prefer-dist "laravel/laravel=6.*" .
```

### localhost起動
```sh
$ cd path/to/www/
$ docker-compose exec www bash # コンテナに入る
$ php artisan serve --host 0.0.0.0 --port 8000
```

上記コマンドを実行後、 `http://localhost` にアクセスすると、 Laravel初期画面が表示される。

### envファイルにDB設定を追記
LaravleからMySQLに接続するためには、下記を `/www/.env` に追記する必要がある。

```sh
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=test_database
DB_USERNAME=docker
DB_PASSWORD=docker
```
