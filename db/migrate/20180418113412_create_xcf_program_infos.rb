class CreateXcfProgramInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :xcf_program_infos, primary_key: "F_id", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      t.string          :F_name
      t.integer         :F_type_id
    end
  end
end
