# Terraform構築

Terraformを利用してAWSインフラを構築するためのテンプレート。  
このテンプレートはdocker-composeを利用してTerraformを起動するため、マシン本体にTerraformをインストールする必要はない。

## 手順

### アプリケーション・ライブラリのインストール

もし以下のアプリケーション または ライブラリがマシンに入っていないならば、インストールすること。

* Docker Desktop for Mac または Docker Desktop for Windows
* docker-compose
* awscli v2

### IAMアカウントの作成

以下の条件に合致する IAMアカウントがすでに存在するならば、それを使用すれば良いので、新たに作成する必要はない。

* AWS アクセスの種類: `アクセスキー - プログラムによるアクセス` が許可されている
* アクセス許可: `AdministratorAccess` 権限 がアタッチされている

`AdministratorAccess` は、あらゆるAWSリソースを構築・修正・破壊できる最強の権限であるため、これをアタッチしたIAMアカウントの取り扱いは注意すること。  
あらかじめterraformで構築するリソースが完全に想定できている場合（EC2・RDS・CloudFront・S3のみ、など）は、それらのみを構築・修正・破壊可能なポリシーを個別にアタッチしたほうが安心ではある。

この IAMアカウントを作成すると、 アクセスキーとシークレットアクセスキーの2種類が表示されるので、これを控えておくこと。
この2種類は次の手順で使用する。

### aws profile の登録

上記の IAMアカウントを発行したら、以下コマンドでMac本体に aws profile を追加し、awscli経由でawsにアクセスできるようにする。

```console
$ aws configure --profile PROFILE_NAME
```

`PROFILE_NAME` は自分のマシンの中で一意となる名前（プロフィール名）なら何でもいい。もし自分のマシンに入っているプロフィール名がわからなければ、以下のコマンドで全て確認することができる。

```console
$ aws configure list-profiles
```

最後に、以下コマンドで正常に自分自身の情報を取得できることを確認する。

```console
$ aws sts get-caller-identity --profile PROFILE_NAME
```

## .env にプロフィール名を追記する

.env.example を .env としてコピーし、上記で登録したプロフィール名を .env に追記する。

```console
$ cd /path/to/
$ cp .env.example .env
```

追記例

```diff
- AWS_PROFILE=
+ AWS_PROFILE=PROFILE_NAME 
```

これにより、以降で実行する `docker-compose run --rm terraform` は、そのプロフィールで実行されることになる。

## trファイルの作成・編集

必要に応じて `tf` ディレクトリ内の `.tf` ファイルを追加・編集する。  
各 .tr ファイルの具体的な記述方法は [公式ドキュメント](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)を読むと良い。

## デプロイする

ここから先の `docker-compose` コマンドは全て、`docker-compose.yml` が置かれているディレクトリで実行する。 `tf` ディレクトリでは無い点に注意。

### モジュールのダウンロード

tf ファイルが作成し終わったら、まず以下コマンドを実行し、 terraformの実行に必要なモジュール群をダウンロードする。これは node で言うところの `npm i` のようなものである。この実行では AWS へのデプロイは一切行われない。

```console
$ docker-compose run --rm terraform init 
```

### 実行計画の確認

次に、以下コマンドで 実行計画を確認する。
このコマンドを実行することで、どのようなリソースがどのような設定で作成されるのかを確認することができる。
同時に、 `.tfファイル` のバリデーションも実行されるため、明らかな構文エラーはここで発見することができる。

```console
$ docker-compose run --rm terraform plan
```

### デプロイ

実行確認が問題なければ、以下コマンドでデプロイを行う。

```console
$ docker-compose run --rm terraform apply
```

デプロイにかかる時間はリソースによって異なるが、RDSは特に長い。RDSだけで5分ほどかかることもあるので、辛抱強く待つ。

## その他

以下のコマンドでhelpが表示できる。

```console
$ docker-compose run --rm terraform -help
```
