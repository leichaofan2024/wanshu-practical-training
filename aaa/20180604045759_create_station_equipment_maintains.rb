class CreateStationEquipmentMaintains < ActiveRecord::Migration[5.0]
  def change
    create_table :station_equipment_maintains do |t|
      t.string :station_name
      t.string :t_type
      t.datetime :begin_time
      t.datetime :end_time, default: "2030-01-01 00:00:00"
      t.text :maintain_reason
      t.timestamps
    end
  end
end
