class MessagesCell < Cell::ViewModel
  include SessionsHelper
  def show(args)
    @messages = args[:messages]
    render
  end

end
