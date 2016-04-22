class MessageBoard < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :item, class_name: "Item"
  
  has_many :messages , foreign_key: "message_board_id" , dependent: :destroy
  has_many :favorites, foreign_key: "message_board_id" , dependent: :destroy
  
  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 50 }
  
  def favorited_by? user
    favorites.where(user_id: user.id).exists?
  end
end