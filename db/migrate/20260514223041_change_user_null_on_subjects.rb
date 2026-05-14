class ChangeUserNullOnSubjects < ActiveRecord::Migration[8.1]
  def change
    change_column_null :subjects, :user_id, false
  end
end
