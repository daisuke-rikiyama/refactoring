class Clip < ActiveRecord::Base
  belongs_to :user,     class_name: "User"
  belongs_to :message,  class_name: "Message"
end
