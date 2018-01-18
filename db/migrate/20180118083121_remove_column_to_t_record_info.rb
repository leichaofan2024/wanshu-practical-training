class RemoveColumnToTRecordInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :t_record_info, :created_at
  end
end
