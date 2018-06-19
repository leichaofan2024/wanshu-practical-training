class ChangeColumnOfStation < ActiveRecord::Migration[5.0]
  def change
    remove_column :t_station_info,:image
  end
end
