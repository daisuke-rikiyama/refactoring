class AddVideoUrlToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :video_url, :string
  end
end
