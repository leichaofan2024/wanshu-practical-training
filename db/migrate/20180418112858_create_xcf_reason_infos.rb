class CreateXcfReasonInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :xcf_reason_infos, primary_key: "F_id", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.integer       :F_reason_type_id
      t.string        :F_name
      t.integer       :F_value

    end
  end
end
