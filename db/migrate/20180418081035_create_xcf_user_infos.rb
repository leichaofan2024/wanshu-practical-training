class CreateXcfUserInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :xcf_user_infos,primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string         :F_name
      t.string         :F_id
      t.integer        :F_type
      t.string         :F_duan_uuid
      t.string         :F_station_uuid
      t.string         :F_team_uuid
      t.string         :F_work_uuid

      t.timestamps
    end
    add_index :xcf_user_infos, :F_uuid
    add_index :xcf_user_infos, :F_id
    add_index :xcf_user_infos, :F_duan_uuid
    add_index :xcf_user_infos, :F_station_uuid
  end
end
