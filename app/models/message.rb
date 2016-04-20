class Message < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :message_board, class_name: "MessageBoard"
  belongs_to :item, class_name: "Item"
  
  validates :user_id, presence: true
  validates :message_board_id, presence: true
  validates :content, presence: true, length: { maximum:2000 }
  validates :video_url, format: { with: /\A(http|https):\/\/www\.youtube\.com\/watch\?v=.*\z/ },
                      allow_blank: true
  validates :item_id, numericality: {only_integer: true}, allow_blank: true
  has_many :clips, class_name: "Clip", foreign_key: "message_id", dependent: :destroy
  has_many :users, through: :clips, source: :user
end
