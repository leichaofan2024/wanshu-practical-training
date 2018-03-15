class AddColumnToTRecordInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_record_info,:time_length,:time
  end
end
