class AddImageToTStationInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_station_info,:image, :string 
  end
end
