class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user, index: true
      t.references :message_board, index: true

      t.timestamps null: false
      
      t.index :created_at
    end
  end
end
