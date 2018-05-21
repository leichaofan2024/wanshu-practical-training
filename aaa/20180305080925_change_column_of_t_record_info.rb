class ChangeColumnOfTRecordInfo < ActiveRecord::Migration[5.0]
  def change
    change_column :t_record_info,:time_length,:integer
  end
end
