class AddColumnToTVacationInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_vacation_infos,:station_name,:string
  end
end
