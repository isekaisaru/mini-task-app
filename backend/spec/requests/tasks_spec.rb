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

  describe "DELETE /tasks/:id" do
    it "他のユーザーのタスクは削除できない"do
    # Arrange　AさんとBさんを作り、　Bさんのタスクを作る
    User.create!(email: "test@example.com", password: "password")
    user_b = User.create!(email: "test2@example.com", password: "password")
    task_b_1 = Task.create!(user: user_b, title: "Task B1", scheduled_on: Date.today)
    
    # Act Aさんでログインして、Bさんのタスクを削除する
    post "/sessions", params: {email: "test@example.com",password: "password"}
    delete "/tasks/#{task_b_1.id}"
  
    # Assert 削除できず404を返す
    expect(response).to have_http_status(:not_found)
    # Assert BのタスクがDBに残っていることを確認する
    expect(Task.exists?(task_b_1.id)).to be_truthy
    end  
  end

  describe " PATCH /tasks/:id" do
    it "他のユーザーのTaskは更新できない" do
      # Arrange
     User.create!(email: "test@example.com", password: "password")
      user_b = User.create!(email: "test2@example.com", password: "password")
      task_b_1 = Task.create!(user: user_b, title: "Task B1", scheduled_on: Date.today)
      # Act AさんでログインしてBさんのタスクを更新しようとする
      post "/sessions", params: {email: "test@example.com",password: "password"}
      patch "/tasks/#{task_b_1.id}", params: {task: {title: "Task B1 Updated"}}
      # Assert 他の人のタスクなので404(Not Found)が返ってくる
      expect(response).to have_http_status(:not_found)
      # Assert DBに変更がないことを確認
      expect(Task.find(task_b_1.id).title).to_not eq("Task B1 Updated")
    end
  end

  describe " POST /tasks" do
    it "Aさんでログインしているなら、絶対に「Aさんのタスク」として作られる（他人の名義では作れない）" do
      #Arrange AさんBさん作成
      user_a = User.create!(email: "test@example.com", password: "password")
      user_b = User.create!(email: "test2@example.com", password: "password")
      # Act  Aさんがログインし、わざとBさんのIDを指定してタスクを作成する
      post "/sessions", params: {email: "test@example.com",password: "password"}
      post "/tasks", params: {task: {title: "Task A1", scheduled_on: Date.today, user_id: user_b.id}}
      
      # Assert　　レスポンスは 201 Created で作れること　でも、作られたタスクの持ち主（task.user_id）は、Bではなく必ず「Aさん（ログインしている人）」になっていること！
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['user_id']).to eq(user_a.id) # ここが超重要！

      
      
    end
  end
end