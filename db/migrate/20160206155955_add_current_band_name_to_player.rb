class AddCurrentBandNameToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :currentBandName, :string
  end
end
