class CreateXcfRecordInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :xcf_record_infos,primary_key: "F_uuid", id: :string, limit: 64, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string             :F_user_uuid
      t.string             :F_location
      t.integer            :F_score
      t.datetime           :F_begin_time
      t.integer            :time_length
      t.string             :F_teacher_uuid
      t.string             :F_question_name
      t.string             :F_record
      t.string             :F_pre_work_uuid
      t.string             :F_bs_name
      t.timestamps
    end
    add_index :xcf_record_infos, :F_user_uuid
    add_index :xcf_record_infos, :F_score
  end
end
