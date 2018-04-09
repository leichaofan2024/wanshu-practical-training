class AddColumnToTBaogaoInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :t_baogao_infos, :kuaizhao_create_time , :datetime 
  end
end
