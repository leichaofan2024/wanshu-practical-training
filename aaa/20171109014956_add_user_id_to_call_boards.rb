class AddUserIdToCallBoards < ActiveRecord::Migration[5.0]
  def change
    add_column :call_boards,:user_id,:integer 
  end
end
