class AddTitleToPhase < ActiveRecord::Migration[8.1]
  def change
    add_column :phases, :title, :string
  end
end
