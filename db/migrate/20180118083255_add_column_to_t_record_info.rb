class AddColumnToTRecordInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_record_info, :created_at, :datetime ,default: -> {"CURRENT_TIMESTAMP"}
  end
end
