class AddPositionToPhases < ActiveRecord::Migration[8.1]
  def change
    add_column :phases, :position, :integer
  end
end
