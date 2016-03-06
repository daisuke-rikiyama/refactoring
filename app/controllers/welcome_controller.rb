class WelcomeController < ApplicationController
    
    def home
        @items = Item.all.order(updated_at: :desc).limit(30)
    end
    
end
