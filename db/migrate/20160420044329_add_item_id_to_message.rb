class AddItemIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :item_id, :integer, index: true
  end
end
