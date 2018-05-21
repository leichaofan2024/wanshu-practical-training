class ChangeColumnToCallBoard < ActiveRecord::Migration[5.0]
  def change
    change_column :call_boards, :content,:string,limit: 5000
  end
end
