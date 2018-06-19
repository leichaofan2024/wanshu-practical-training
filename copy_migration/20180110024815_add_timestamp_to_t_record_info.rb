class AddTimestampToTRecordInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_record_info, :created_at , :datetime ,null: false
    add_column :t_record_info, :updated_at , :datetime ,null: false
  end
end
