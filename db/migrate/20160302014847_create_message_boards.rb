class CreateMessageBoards < ActiveRecord::Migration
  def change
    create_table :message_boards do |t|
      t.references :user, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true
      t.string :title

      t.timestamps null: false
      
      t.index [:updated_at]
    end
  end
end
