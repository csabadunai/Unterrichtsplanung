class CreatePhases < ActiveRecord::Migration[8.1]
  def change
    create_table :phases do |t|
      t.integer :duration
      t.string :social
      t.text :description
      t.text :differentiation
      t.string :materials

      t.timestamps
    end
  end
end
