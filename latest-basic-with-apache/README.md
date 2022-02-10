# Latest Basic With PHP
PHP最新版 + MySQL + apache で手短にローカル環境を構築するための、シンプルなDocker環境のセット。

## Dockerコンテナのビルド手順

### コンテナ起動
初回実行時のみ、まあまあ時間がかかる。5分ぐらい。
```sh
cd path/to/
docker-compose up -d
```

コンテナを起動すると、apacheが自動で立ち上がるため、 `http://localhost` にアクセスすると `/www/index.php` の内容が表示される。  
（コンテナ内に入って `php artisan serve` や `php -S` などのコマンドを実行する必要はない）

### コンテナログイン（Webサーバ）

```sh
$ docker-compose exec www bash # Webサーバのコンテナにログイン
```

### コンテナログイン（DBサーバ）

```sh
$ docker-compose exec mysql bash # DBサーバのコンテナにログイン
$ mysql -u docker -p
Enter password: # 「docker」 を入力
> use docker;
```

### 動作確認
```sh
$ cd path/to/www/
$ docker-compose exec www bash # コンテナに入る
```

上記コマンドを最後まで実行後、 `http://localhost` にアクセスすると、3行目で入力した内容が表示される。

## Laravelを使用する場合
### .gitkeepファイルを削除
Laravelは `www` ディレクトリが空でないとインストールできない。
そのため、 `www` ディレクトリ内にある `.gitkeep` ファイルを削除する。

```sh
$ cd path/to/www/
$ rm index.php
```

### インストールコマンド
下記のコマンドで、Laravelの6.x（LTS最新）がインストールされる。

```sh
$ cd path/to/www/
$ docker-compose exec www bash # コンテナに入る
$ composer create-project --prefer-dist "laravel/laravel=6.*" .
```

### envファイルにDB設定を追記
LaravelからMySQLに接続するためには、下記を `/www/.env` に追記する必要がある。

```sh
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=docker
DB_USERNAME=docker
DB_PASSWORD=docker
```

## 特記事項
* MySQL データの実体（データベース・テーブル・レコードなど）は、`Docker/MySQL/var/lib/mysql` となる。データベースを完全に削除した上で、`docker-compose.yml` の定義に従って作り直しをしたい場合、少々強引だが、次のようにファイル削除後、コンテナを構築&起動すれば良い。

```bash
$ rm -rf Docker/MySQL/var/lib/mysql
$ docker compose up -d
```