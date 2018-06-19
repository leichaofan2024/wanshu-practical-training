class AddAttachment2ToStationInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_station_info, :attachment2, :string
  end
end
