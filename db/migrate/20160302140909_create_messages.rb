class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true
      t.references :message_board, index: true
      t.text :content

      t.timestamps null: false
      
      t.index [:user_id, :updated_at]
    end
  end
end
