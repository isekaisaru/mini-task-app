require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "正常に取得ができる" do
      get "/tasks"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /tasks" do
    context "正しい値を送った場合" do
      it "Taskを1件作成できる" do
        user = User.create!(
          email: "test@example.com",
          password_digest: "test-password"
        )

        task_params = {
          title: "勉強する",
          duration_minutes: 30,
          scheduled_on: "2026-08-05",
          user_id: user.id,
          completed: false
        }

        expect {
          post "/tasks", params: { task: task_params }
        }.to change(Task, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "タイトルが空の場合" do
      it "Taskを作成できず422を返す" do
        user = User.create!(
          email: "invalid-task-20260807@example.com",
          password_digest: "test-password"
        )

        task_params = {
          title: "",
          duration_minutes: 30,
          scheduled_on: "2026-08-05",
          user_id: user.id,
          completed: false
        }

        expect {
          post "/tasks", params: { task: task_params }
        }.not_to change(Task, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end