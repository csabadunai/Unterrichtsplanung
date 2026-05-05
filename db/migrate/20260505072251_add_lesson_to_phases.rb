class AddLessonToPhases < ActiveRecord::Migration[8.1]
  def change
    add_reference :phases, :lesson, null: false, foreign_key: true
  end
end
