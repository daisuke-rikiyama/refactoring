class MessageBoard < ActiveRecord::Base
  belongs_to :user, class_name: "USer"
  belongs_to :item, class_name: "Item"
  
  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 50 }
end
