class RankingController < ApplicationController

  def have
    @type = "haves"
  end
  
  def want
    @type = "wants"
  end
  
end
