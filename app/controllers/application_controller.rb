class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!
    helper_method [:duan_z, :duan_cw, :duan_ju, :teacher,:station_ju]

    def all_browsed?
      call_board_ids = current_user.browses.pluck(:call_board_id)
      if current_user.permission == 1 || current_user.permission ==2
        call_boards = CallBoard.where(user_id: User.where(:permission => 1).ids)
        if (call_boards.ids - call_board_ids).present?
          flash[:alert] = "您有新公告未读！请前往查看～"
        end
      else current_user.permission ==3
        duan = TStationInfo.find_by(:F_name => current_user.orgnize).t_duan_info
        call_boards_1 = CallBoard.where(user_id: User.where(:permission => 1).ids).ids
        call_boards_2 = User.find_by(:orgnize => duan.F_name).call_boards.ids
        call_boards = call_boards_1 + call_boards_2
        if (call_boards - call_board_ids).present?
          flash[:alert] = "您有新公告未读！请前往查看～"
        end
      end
    end


    def duan_z
        m = TDuanInfo.where(F_type: 2)
    end

    def duan_cw
        m = TDuanInfo.where(F_type: 1)
    end

    def duan_ju
        m = TDuanInfo.duan_zhijiao
    end

    def station_ju
        m = TStationInfo.includes(:t_record_infoes).station_zhijiao
    end

    def teacher
        m = TUserInfo.where(F_type: 1)
    end

end
