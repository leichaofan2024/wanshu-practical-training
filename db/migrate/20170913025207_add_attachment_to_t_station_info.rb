class AddAttachmentToTStationInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_station_info, :attachment, :string
  end
end
