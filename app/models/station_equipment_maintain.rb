class StationEquipmentMaintain < ApplicationRecord
validates :equipment_come_from, presence: true
validates :equipment_used_time_lenth, presence: true
validates :station_name, presence: true
validates :t_type, presence: true
validates :maintain_reason, presence: true


  def self.equipment_maintain(date_from,date_to)
    a = StationEquipmentMaintain.where("station_equipment_maintains.begin_time < ? and station_equipment_maintains.end_time > ? ",date_to,date_to).pluck("station_equipment_maintains.station_name")
    b = TStationInfo.where(:F_name => a).pluck(:F_uuid)
    return b
  end


end
