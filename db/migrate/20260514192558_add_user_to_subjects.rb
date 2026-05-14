class AddUserToSubjects < ActiveRecord::Migration[8.1]
  def change
    add_reference :subjects, :user, null: true, foreign_key: true
  end
end
