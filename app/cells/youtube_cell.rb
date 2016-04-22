class YoutubeCell < Cell::ViewModel
  def show(args)
    @message = args[:message]
    @url = @message[:video_url]
    if @url
      @array = @url.split("=")
      @movie_id = @array[1]
    end
    render
  end

end
