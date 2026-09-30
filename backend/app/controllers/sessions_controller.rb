class SessionsController < ApplicationController

  def create
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      render json: {message: "ログインしました。"}, status: :ok
    else
      render json: {error: "メールアドレスまたはパスワードが正しくありません。"}, status: :unauthorized
    end
  end

  def me
    response.headers["Cache-Control"] = "no-store"
    user = User.find_by(id: session[:user_id])
    if user
      render json: {id: user.id, email: user.email}, status: :ok
    else
      render json: {error: "ログインしていません。"}, status: :unauthorized
    end
  end

  def destroy
    reset_session
    render json: {message: "ログアウトしました。"}, status: :ok
  end

end