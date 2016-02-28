class WelcomeController < ApplicationController
    
    def index
        @items = Item.all.order(updated_at: :desc).limit(30)
    end
    
end
