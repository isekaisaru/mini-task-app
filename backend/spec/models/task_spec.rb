require "rails_helper"

RSpec.describe Task, type: :model do
  describe "validation" do
    it "titleが空ならblankエラーになる" do
      task = Task.new(title: "")
      task.valid?
      expect(task.errors.of_kind?(:title, :blank)).to be(true)
    end
  end
end

