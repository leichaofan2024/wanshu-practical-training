class CallBoardsController < ApplicationController
  before_action :authenticate_user!
  layout "notime_frame"
  def index
    @call_boards = CallBoard.all.order("id DESC")
  end

  def show
    @call_board = CallBoard.find(params[:id])
  end

  def new
    @call_board = CallBoard.new
  end

  def create
    @call_board = CallBoard.new(call_board_params)
    if @call_board.save
      redirect_to call_boards_path
    else
      render :new
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
    params.require(:call_board).permit(:name,:content,{call_board_attachments: []})
  end



end
