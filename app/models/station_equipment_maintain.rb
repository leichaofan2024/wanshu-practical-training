class StationEquipmentMaintain < ApplicationRecord

  def self.equipment_maintain(date_from,date_to)
    a = StationEquipmentMaintain.where("station_equipment_maintains.begin_time < ? and station_equipment_maintains.end_time > ? ",date_to,date_to).pluck("station_equipment_maintains.station_name")
    b = TStationInfo.where(:F_name => a).pluck(:F_uuid)
    return b
  end


end
