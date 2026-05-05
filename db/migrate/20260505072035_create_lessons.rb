class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.string :title
      t.datetime :start_time
      t.integer :duration, default: 1

      t.timestamps
    end
  end
end
