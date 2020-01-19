class AddDiscussionReferencesToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :discussion, null: true, foreign_key: true
  end
end
