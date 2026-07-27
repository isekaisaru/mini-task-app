class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :duration_minutes, null: false, default: 15
      t.boolean :completed, null: false, default: false
      t.date :scheduled_on, null: false
      t.timestamps
    end
  end
end
