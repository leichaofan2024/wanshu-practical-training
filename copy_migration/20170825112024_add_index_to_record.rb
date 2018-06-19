class AddIndexToRecord < ActiveRecord::Migration[5.0]
  def change
    add_index :t_record_info, :F_team_uuid
    add_index :t_record_info, :F_user_uuid
    add_index :t_record_info, :F_score
    add_index :t_record_info, :F_work_uuid 
    add_index :t_duan_info, :F_name
    add_index :t_station_info, :F_duan_uuid
    add_index :t_team_info, :F_station_uuid
    add_index :t_user_info, :F_team_uuid
    add_index :t_user_info, :F_type


  end
end
