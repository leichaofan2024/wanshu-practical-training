class CreateXcfReasonTypeInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :xcf_reason_type_infos, primary_key: "F_id", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.string           :F_name
    end
  end
end
