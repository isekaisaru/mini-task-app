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
    task = Task.new(task_params)

    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages },status: :unprocessable_entity

    end
  end

    def update
      task = Task.find(params[:id])
      if task.update(task_params)
        render json: task
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      # URLからTaskのIDを受け取る
      task = Task.find(params[:id])

      # 見つけたTaskをDBから削除する
      task.destroy
      
      # 削除成功のレスポンスを返す
      render json: { message: "Task deleted" }, status: :ok
    end
      

  private

  def task_params
    params.require(:task).permit(
      :title,
      :duration_minutes,
      :scheduled_on,
      :user_id,
      :completed
    )

  end

end
