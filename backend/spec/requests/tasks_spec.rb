require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "ログイン中のユーザーのTaskだけ取得できる" do
      #Arrange ログインしておく
      user_a = User.create!(email: "test@example.com", password: "password")
      user_b = User.create!(email: "test2@example.com", password: "password")
      task_a_1 = Task.create!(user: user_a, title: "Task A1", scheduled_on: Date.today)
      task_a_2 = Task.create!(user: user_a, title: "Task A2", scheduled_on: Date.today)
      task_b_1 = Task.create!(user: user_b, title: "Task B1", scheduled_on: Date.today)
      
      post "/sessions", params: {email: "test@example.com",password: "password"}
      #Act 自分のタスクを取得
      get "/tasks"
      #Assert 200が返ってくる
      expect(response).to have_http_status(:ok)
      # bodyに task_a_1とtask_a_2が含まれている
      expect(response.body).to include("Task A1")
      expect(response.body).to include("Task A2")
      # bodyに task_b_1が含まれていない
      expect(response.body).to_not include("Task B1")
    end
    
  end
end