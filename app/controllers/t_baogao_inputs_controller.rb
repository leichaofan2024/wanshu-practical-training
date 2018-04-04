class TBaogaoInputsController < ApplicationController
  def new
    @t_baogao_input = TBaogaoInput.new
  end

  def create
    @t_baogao_input = TBaogaoInput.new(t_baogao_input_params)
    if @t_baogao_input.save
      redirect_to baogao_path
    else
      render :new
      flash[:warning] = "输入框不能为空，且月份不可与往月重复"

    end
  end

  def edit
    @t_baogao_input = TBaogaoInput.find(params[:id])

  end

  def update
    @t_baogao_input  = TBaogaoInput.find(params[:id])
    if @t_baogao_input.update(t_baogao_input_params)
      redirect_to baogao_path
    else
      render :edit
      flash[:warning] = "输入框不能为空，且月份不可与往月重复"
    end
  end


  private

  def t_baogao_input_params
    params.require(:t_baogao_input).permit(:title,:content,{:baogao_attachment => []},:baogao_time )
  end
end
