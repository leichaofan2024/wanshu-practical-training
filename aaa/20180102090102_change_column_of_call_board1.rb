class ChangeColumnOfCallBoard1 < ActiveRecord::Migration[5.0]
  def change
    change_column :call_boards,:content,:text,limit: 1000000
  end
end
