require "rails_helper"


RSpec.describe User, type: :model do
  describe "authenticate" do
    it "正しいパスワードなら認証できる" do
       #Arrange
       user = User.create(email: "test@example.com",password: "password123")

       #Act
       result = user.authenticate("password123")

       #Assert
       expect(result).to eq(user)
    end

    it "間違ったパスワードなら認証できない" do
       #Arrange
       user = User.create(email: "test@example.com",password: "password123")
      
       #Act
       result = user.authenticate("wrongpassword")

       #Assert
       expect(result).to be_falsy
    end
  end
end