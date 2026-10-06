require "rails_helper"


RSpec.describe "Users", type: :request do
  let(:valid_origin_header) do
    { "Origin" => "http://localhost:3000" }
  end

  describe "POST #create" do
    context "正しいパラメータ" do
      it "ユーザーを登録できる" do
       #Arrange(送信するデータの準備)
       user_params = {email: "test@example.com", password: "password123",password_confirmation: "password123"}
       #Act
       expect {
       post users_path, params: { user: user_params}, headers: valid_origin_header
       }.to change(User, :count).by(1)

       #Assert(レスポンスと保存内容の検証)
       expect(response).to have_http_status(:created)

       expect(User.last.email).to eq("test@example.com")
      end
    end
    context "パスワードが一致しない" do
      it "ユーザー登録に失敗する" do
        #Arrange(一致しないデータを準備)
        invalid_params = {email: "test@example.com",password: "password123",password_confirmation: "wrongpassword"}
        #Act & Assert(POSTしてもUserの件数が変わらないことを検証)
        expect {
          post users_path, params: {user: invalid_params}, headers: valid_origin_header
      }.not_to change(User, :count)
        # Assert (HTTPステータスが422になることを検証)
          expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "メールアドレスが重複" do
      it "ユーザー登録に失敗する" do
        #Arrange(既存のユーザーと同じメールアドレスを用意)
        User.create!(email: "test@example.com", password: "password123")
        invalid_params = {email: "test@example.com",password: "password123",password_confirmation: "password123"}

        #Act & Assert
        expect {
          post users_path, params: {user: invalid_params}, headers: valid_origin_header
        }.to change(User, :count).by(0)

        # Assert
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end