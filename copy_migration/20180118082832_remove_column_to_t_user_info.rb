class RemoveColumnToTUserInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :t_user_info, :created_at
    remove_column :t_user_info, :updated_at
  end
end
