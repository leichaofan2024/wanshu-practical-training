class TChejianCountsController < ApplicationController
  def new
    @duan_name = params[:duan_name]
    @t_chejian_count = TChejianCount.new
  end

  def create
    @t_chejian_count = TChejianCount.new(t_chejian_count_params)
    if @t_chejian_count.save
      redirect_to baogao_path
    else
      render :new
      flash[:warning]= "创建失败"
    end
  end

  def edit
    @duan_name = params[:duan_name]
    @t_chejian_count = TChejianCount.find(params[:id])
  end

  def update
    @t_chejian_count = TChejianCount.find(params[:id])
    if @t_chejian_count.update(t_chejian_count_params)
      redirect_to baogao_path
    else
      render :edit
    end

  end

  private

  def t_chejian_count_params
    params.require(:t_chejian_count).permit(:duan_name ,:station_count)
  end

end
