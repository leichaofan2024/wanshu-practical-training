class CreateTChejianCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :t_chejian_counts do |t|
      t.string   :duan_name
      t.integer  :station_count
      t.timestamps
    end
    add_index :t_chejian_counts, :duan_name, unique: true
  end
end
