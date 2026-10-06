class UsersController < ApplicationController

  def create
    user = User.new(user_params)

    if user.save
      render json: { id: user.id, email: user.email, created_at: user.created_at }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_content
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end