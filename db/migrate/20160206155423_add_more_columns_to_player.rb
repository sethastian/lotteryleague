class AddMoreColumnsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :band2008, :string
    add_column :players, :band2010, :string
    add_column :players, :band2013, :string
    add_column :players, :description, :text
  end
end
