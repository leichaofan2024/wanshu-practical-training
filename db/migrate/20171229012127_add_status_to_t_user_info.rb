class AddStatusToTUserInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_user_info, :status, :string ,default: "在职"
  end
end
