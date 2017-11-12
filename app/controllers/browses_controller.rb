class BrowsesController < ApplicationController
  layout "notime_frame"
  def index
    @call_board = CallBoard.find(params[:call_board_id])
    @users = @call_board.browses.order("id DESC").group_by{|b| b.user.role}
  end
end
