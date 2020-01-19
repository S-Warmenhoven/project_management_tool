class AddBodyToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :body, :text
    add_column :tasks, :is_done, :boolean, default: false
    add_reference :tasks, :project, foreign_key: true
  end
end
