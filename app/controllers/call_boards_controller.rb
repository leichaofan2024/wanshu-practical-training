class CallBoardsController < ApplicationController
  before_action :authenticate_user!
  layout "notime_frame"
  def index
    @call_boards = CallBoard.all.order("id DESC")
  end

  def duan_call_boards
    @call_boards = CallBoard.joins(:user).where("users.permission" => 2).order("id DESC").group_by{|c| c.user.orgnize}
  end

  def show
    @call_board = CallBoard.find(params[:id])
    Browse.create(:user_id => current_user.id,:call_board_id => @call_board.id)
    @browses = @call_board.browses.group(:user_id).count
    pry
  end

  def new
    @call_board = CallBoard.new
  end

  def create
    @call_board = CallBoard.new(call_board_params)
    @call_board.user_id = current_user.id
    if @call_board.save
      redirect_to call_boards_path
    else
      render :new
      flash[:warning] = "标题不能为空！"
    end
  end

  def edit
    @call_board = CallBoard.find(params[:id])
  end

  def update
    @call_board = CallBoard.find(params[:id])
    if @call_board.update(call_board_params)
      redirect_to call_boards_path
    else
      render :edit
    end
  end

  def destroy
    @call_board = CallBoard.find(params[:id])
    @call_board.destroy
    redirect_to call_boards_path
  end

  private


  def call_board_params
    params.require(:call_board).permit(:name,:content,:user_id,{call_board_attachments: []})
  end



end
