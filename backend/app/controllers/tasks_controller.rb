class TasksController < ApplicationController
  def index
    user = User.find_by(id: session[:user_id])
    return render json: {errors: "ログインしていません。"} ,status: :unauthorized unless user
    render json: user.tasks
  end

  def show
    user = User.find_by(id: session[:user_id])
    return render json: {errors: "ログインしていません。"} ,status: :unauthorized unless user
    task = user.tasks.find(params[:id])
    render json: task
  end

  def create
    user = User.find_by(id: session[:user_id])
    return render json: {errors: "ログインしていません。"} ,status: :unauthorized unless user
    task = user.tasks.new(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages },status: :unprocessable_entity

    end
  end

    def update
      user = User.find_by(id: session[:user_id])
      return render json: {errors: "ログインしていません。"} ,status: :unauthorized unless user
      task = user.tasks.find(params[:id])
      if task.update(task_params)
        render json: task
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      user = User.find_by(id: session[:user_id])
      return render json: {errors: "ログインしていません。"} ,status: :unauthorized unless user
      task = user.tasks.find(params[:id])
      task.destroy
      render json: { message: "Task deleted" }, status: :ok
    end
      

  private

  def task_params
    params.require(:task).permit(
      :title,
      :duration_minutes,
      :scheduled_on,
      :completed
    )

  end

end
