class AddStatusToTStationInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_station_info,:status,:string,default: "在线"
  end
end
