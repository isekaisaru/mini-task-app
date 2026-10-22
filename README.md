# Mini Task APP

部屋の片付けが苦手な人が、片付けを小さなTaskに分け、
15分単位で取り組むためのアプリケーションです。

## 開発状況

現在は仕様とデータ設計を作成しています。

## Docker Composeでの開発

最初に環境変数ファイルを作成します。

```bash
cp .env.example .env
```

次に、Docker Composeを起動します。

```bash
docker compose up --build
```

`.env`にはローカル開発用のPostgreSQL接続情報を設定します。`.env`はGit管理されません。
