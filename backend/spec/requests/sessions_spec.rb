require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:valid_origin_header) do
    { "Origin" => "http://localhost:3000" }
  end

  describe "POST /sessions" do
    it "正しいメールアドレスとパスワードならログインできる" do
      # Arrange Userを作る
      User.create!(email: "test@example.com", password: "password")

      # Act セッションを作成する
      post "/sessions", params: {email: "test@example.com", password: "password"}, headers: valid_origin_header
      # Assert レスポンスを確認する
      expect(response).to have_http_status(:ok)
      expect(response.cookies["_mini-task-app_session"]).to be_present

      set_cookie = response.headers["Set-Cookie"].downcase
      expect(set_cookie).to include("path=/")
      expect(set_cookie).to include("httponly")
      expect(set_cookie).to include("samesite=lax")
    end
    it "間違ったパスワードならログインできない" do
      #Arrange 間違ったパスワードでPOSTする
      User.create!(email: "test@example.com", password: "password")
      #Act
      post "/sessions", params: {email: "test@example.com",password: "wrongpassword"}, headers: valid_origin_header
      #Assert: 401　認証失敗のレスポンスが返ってくる
      expect(response).to have_http_status(:unauthorized)
    end
    it "存在しないメールアドレスならログインできない" do
      #Arrange ユーザーは作らない　（または別のアドレスで作る）
      #Act
      post "/sessions", params: {email: "wrong@example.com", password: "password"}, headers: valid_origin_header
      #Assert
      expect(response).to have_http_status(:unauthorized)
    end
  end
  describe "GET /me" do
      it "ログイン中なら、 現在のユーザー情報を取得できる" do
        #Arrange ログインしておく
        user = User.create!(email: "test@example.com", password: "password")
        post "/sessions", params: {email: "test@example.com",password: "password"}, headers: valid_origin_header
        #Act 自分の情報を取得
        get "/me", headers: valid_origin_header
        #Assert 200が返ってくる
        expect(response).to have_http_status(:ok)
        # レスポンスをブラウザへ保存させない
        expect(response.headers["Cache-Control"]).to include("no-store")
        # JSONをRubyのHashに変える
        json = JSON.parse(response.body)
        # bodyに emailが含まれている
        expect(json["email"]).to eq("test@example.com")
        # bodyに idが含まれている
        expect(json["id"]).to eq(user.id)
        # パスワードに関する内部情報は返さない
        expect(json).not_to have_key("password_digest")
      end

      it "ログインしていない状態ではアクセスできない" do
        #Arrange ユーザーは作っておく
        User.create!(email: "test@example.com", password: "password")
        #Act ログインしていない状態で自分の情報を取得
        get "/me", headers: valid_origin_header
        #Assert 401が返ってくる headerは関係ない
        expect(response).to have_http_status(:unauthorized)
        # ログインしていないという結果もブラウザへ保存させない
        expect(response.headers["Cache-Control"]).to include("no-store")
      end
    end

    describe "DELETE /logout" do
      it "ログアウトすると、 その後の /me で401が返る" do
        #Arrange ログインしておく
        User.create!(email: "test@example.com", password: "password")
        post "/sessions", params: {email: "test@example.com",password: "password"}, headers: valid_origin_header
        #Act ログアウトする
        delete "/logout", headers: valid_origin_header
        #Assert 200が返ってくる
        expect(response).to have_http_status(:ok)
        #Cookieが消えている
        #expect(response.cookies["_mini-task-app_session"]).to be_blank
        # その後 /me にアクセスすると401が返る
        get "/me", headers: valid_origin_header
        expect(response).to have_http_status(:unauthorized)
      end
    end
end
