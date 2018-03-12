class UsersController < ApplicationController
layout "notime_frame"
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

  def new_station
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if current_user.permission == 1
      if @user.save
        redirect_to ju_users_path
      else
        render :back
      end
    else current_user.permission == 2
      if @user.save
        redirect_to duan_users_path
      else
        render :back
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      if current_user.permission == 1
        redirect_to ju_users_path
      elsif current_user.permission == 2
        redirect_to duan_users_path
      end
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:alert] = "已删除该角色"
    if current_user.permission == 1
      redirect_to ju_users_path
    elsif current_user.permission == 2
      redirect_to duan_users_path
    end
  end

  def duan_users
    @users = User.where(:permission => 3).where(:orgnize =>TDuanInfo.find_by(:F_name => current_user.orgnize).t_station_infoes.pluck(:F_name))
  end

  def ju_users
    @users = User.where(:orgnize => TDuanInfo.duan_orgnization.pluck(:F_name) + TStationInfo.station_orgnization.pluck(:F_name))
  end

  def new_duan
    @user = User.new
  end

  def new_duan_station
    @user = User.new
    @duans = TDuanInfo.duan_orgnization
  end

  private

  def user_params
    params.require(:user).permit(:role,:password,:password_confirmation,:orgnize,:permission)
  end

end
