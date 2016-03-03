class Favorite < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :message_board, class_name: "MessageBoard"
  
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :message_board_id }
  validates :message_board, presence: true
end
