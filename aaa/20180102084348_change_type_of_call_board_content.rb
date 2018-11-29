class ChangeTypeOfCallBoardContent < ActiveRecord::Migration[5.0]
  def change
    change_column :call_boards,:content,:text
  end
end
