class Message < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :message_board, class_name: "MessageBoard"
  validates :user_id, presence: true
  validates :message_board_id, presence: true
  validates :content, presence: true, length: { maximum:200 }
end
