class Item < ActiveRecord::Base
    serialize :raw_info , Hash
end
