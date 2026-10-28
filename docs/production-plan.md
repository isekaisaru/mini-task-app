# 本番構成の検討

## 現在の通信経路

- ログイン・Task更新: ブラウザ → Rails
- Task一覧取得: ブラウザ → Next.js → Rails
- Next.jsは受信したCookieをRailsへ転送する

## 決めること

- FrontendとBackendの配置先
- ドメイン構成とCookieの送信範囲
- 本番DBの配置先とバックアップ方法

## 環境変数

| 変数 | 設定先 | 用途 |
| --- | --- | --- |
| FRONTEND_ORIGIN | Rails | 許可するFrontendのOrigin |
| DATABASE_URL | Rails | 本番DBへの接続 |
| RAILS_MASTER_KEY | Rails | Rails credentialsの復号 |
| API_URL | Next.jsサーバー | Railsへの接続先 |
| NEXT_PUBLIC_API_URL | Next.js | ブラウザから接続するAPI URL |

秘密値はこの文書へ記載しない。
NEXT_PUBLIC_の値はブラウザへ公開される。

## 次回の確認

- CookieがFrontendとBackendへ届く構成か
- PostgreSQLを本番で使うための設定
- 本番用の起動・migration手順

## API URLを分ける理由

API_URLはNext.jsサーバーからRailsへ接続するときに使う。
NEXT_PUBLIC_API_URLはブラウザからRailsへ接続するときに使う。
Docker内部のbackendという名前はブラウザでは使えないため、接続先を分ける。