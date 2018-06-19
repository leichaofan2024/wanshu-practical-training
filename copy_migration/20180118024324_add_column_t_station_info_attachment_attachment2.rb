class AddColumnTStationInfoAttachmentAttachment2 < ActiveRecord::Migration[5.0]
  def change
    add_column :t_station_info, :image, :json
    add_column :t_station_info, :attachment, :json
    add_column :t_station_info, :attachment2, :json
  end
end
