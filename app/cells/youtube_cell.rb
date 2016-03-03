class YoutubeCell < Cell::ViewModel
  def show(args)
    @message = args[:message]
    @url = @message[:video_url]
    @array = @url.split("=") if @url
    @movie_id = @array[1]
    render
  end

end
