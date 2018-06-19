class AddOrgnizeAndPermissionToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :orgnize,:string
    add_column :users, :permission,:integer
  end
end
