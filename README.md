# README
日報管理API

## 環境構築
cloneしてからdockerでアプリを立ち上げてください🙇‍♀️

`docker-compose up --build -d`
↑DBがセットアップされてrailsサーバーが立ち上がります
コンテナ内へは`docker-compose exec api bash`で入れます

## テスト
コンテナ内で`rspec spec/requests/`を実行してください
