class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.references :user, index: true
      t.references :message, index: true

      t.timestamps null: false
      
      t.index [:user_id, :message_id], unique: true
    end
  end
end
