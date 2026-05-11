class ChangeLessonSubjectIdToNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :lessons, :subject_id, false
  end
end
