class RemoveColumnOfTStationInfoAttachmentAttachment2 < ActiveRecord::Migration[5.0]
  def change
    remove_column :t_station_info, :attachment
    remove_column :t_station_info, :attachment2
  end
end
