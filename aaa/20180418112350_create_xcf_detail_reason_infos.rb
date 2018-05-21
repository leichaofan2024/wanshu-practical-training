class CreateXcfDetailReasonInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :xcf_detail_reason_infos,primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string           :F_record_detail_uuid
      t.datetime         :F_time
      t.integer          :F_reason_id
      t.integer          :F_score
      t.timestamps
    end
  end
end
