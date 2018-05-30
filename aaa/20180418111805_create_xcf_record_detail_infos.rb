class CreateXcfRecordDetailInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :xcf_record_detail_infos,primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string           :F_record_uuid
      t.integer          :F_program_id
      t.integer          :F_score
      t.timestamps
    end
  end
end
