class AddSubjectToLessons < ActiveRecord::Migration[8.1]
  def change
    add_reference :lessons, :subject, null: true, foreign_key: true
  end
end
