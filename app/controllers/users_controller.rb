class UsersController < ApplicationController

  def index
    if current_user.permission ==1
      @users = User.all
    elsif current_user.permission ==2
      @users = User.where(:orgnize =>TDuanInfo.where(:F_name => current_user.orgnize).t_station_infoes.pluck(:F_name))
    end

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path
    else
      render :new 
    end
  end

  private

  def user_params
    params.require(:user).permit(:role,:password,:password_confirmation,:orgnize,:permission)
  end

end
