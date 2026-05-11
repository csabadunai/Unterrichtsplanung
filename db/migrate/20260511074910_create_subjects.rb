class CreateSubjects < ActiveRecord::Migration[8.1]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :group
      t.string :room
      t.text :schedule_data

      t.timestamps
    end
  end
end
