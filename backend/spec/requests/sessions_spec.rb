require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "POST /sessions" do
    it "正しいメールアドレスとパスワードならログインできる" do
      # Arrange Userを作る
      User.create!(email: "test@example.com", password: "password")
      
      # Act セッションを作成する
      post "/sessions", params: {email: "test@example.com", password: "password"}
      # Assert レスポンスを確認する
      expect(response).to have_http_status(:ok)
      expect(response.cookies["_mini-task-app_session"]).to be_present
    end
    it "間違ったパスワードならログインできない" do
      #Arrange 間違ったパスワードでPOSTする
      User.create!(email: "test@example.com", password: "password")
      #Act
      post "/sessions", params: {email: "test@example.com",password: "wrongpassword"}
      #Assert: 401　認証失敗のレスポンスが返ってくる
      expect(response).to have_http_status(:unauthorized)
    end
    it "存在しないメールアドレスならログインできない" do
      #Arrange ユーザーは作らない　（または別のアドレスで作る）
      #Act
      post "/sessions", params: {email: "wrong@example.com", password: "password"}
      #Assert
      expect(response).to have_http_status(:unauthorized)
    end 
  end
  describe "GET /me" do
      it "ログイン中なら、 現在のユーザー情報を取得できる" do
        #Arrange ログインしておく
        user = User.create!(email: "test@example.com", password: "password")
        post "/sessions", params: {email: "test@example.com",password: "password"}
        #Act 自分の情報を取得
        get "/me"
        #Assert 200が返ってくる
        expect(response).to have_http_status(:ok)
        # bodyに emailが含まれている
        expect(response.body).to include("test@example.com")
        # bodyに idが含まれている
        expect(response.body).to include(user.id.to_s)
      end

      it "ログインしていない状態ではアクセスできない" do
        #Arrange
        User.create!(email: "test@example.com", password: "password")
        #Act ログインしていない状態で自分の情報を取得
        get "/me"
        #Assert 401が返ってくる
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE /logout" do
      it "ログアウトすると、 その後の /me で401が返る" do
        #Arrange ログインしておく
        user = User.create!(email: "test@example.com", password: "password")
        post "/sessions", params: {email: "test@example.com",password: "password"}
        #Act ログアウトする
        delete "/logout"
        #Assert 200が返ってくる
        expect(response).to have_http_status(:ok)
        #Cookieが消えている
        #expect(response.cookies["_mini-task-app_session"]).to be_blank
        # その後 /me にアクセスすると401が返る
        get "/me"
        expect(response).to have_http_status(:unauthorized)
      end
    end
end
