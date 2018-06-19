class AddIndexToDuan < ActiveRecord::Migration[5.0]
  def change
    add_index :t_record_info, :F_station_uuid
    add_index :t_record_info, :F_duan_uuid
    
  end
end
