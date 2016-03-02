class MessageBoardsCell < Cell::ViewModel
  include SessionsHelper
  def show(args)
    @message_boards = args[:message_boards]
    render
  end

end
