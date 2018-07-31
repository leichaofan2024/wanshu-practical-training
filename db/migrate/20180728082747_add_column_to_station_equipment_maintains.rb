class AddColumnToStationEquipmentMaintains < ActiveRecord::Migration[5.0]
  def change
    add_column :station_equipment_maintains,:equipment_come_from,:string
    add_column :station_equipment_maintains,:equipment_used_time_lenth,:string
  end
end
