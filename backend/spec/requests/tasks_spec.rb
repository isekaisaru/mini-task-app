require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "ログイン中のユーザーのTaskだけ取得できる" do
      #Arrange ログインしておく
      user_a = User.create!(email: "test@example.com", password: "password")
      user_b = User.create!(email: "test2@example.com", password: "password")
      Task.create!(user: user_a, title: "Task A1", scheduled_on: Date.today)
      Task.create!(user: user_a, title: "Task A2", scheduled_on: Date.today)
      Task.create!(user: user_b, title: "Task B1", scheduled_on: Date.today)
      
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

  describe "GET /tasks/:id" do
    it "他のユーザーのTaskは取得できない" do
      # Arrange　AさんとBさんを作り、　Bさんのタスクを作る
      User.create!(email: "test@example.com", password: "password")
      user_b = User.create!(email: "test2@example.com", password: "password")
      task_b_1 = Task.create!(user: user_b, title: "Task B1", scheduled_on: Date.today)
      # Act user_a でログインして task_b_1を見に行こうとする
      post "/sessions", params: {email: "test@example.com",password: "password"}
      get "/tasks/#{task_b_1.id}"
      # Assert 他の人のタスクなので 404( Not Found ) になることを期待する
      expect(response).to have_http_status(:not_found)
    end

  end
end