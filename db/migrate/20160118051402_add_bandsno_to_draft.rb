class AddBandsnoToDraft < ActiveRecord::Migration
  def change
    add_column :drafts, :numberOfBands, :integer
  end
end
