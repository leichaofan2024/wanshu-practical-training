class RemoveIndexToUser < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :email
    add_index :users,:role ,:unique => true 
  end
end
