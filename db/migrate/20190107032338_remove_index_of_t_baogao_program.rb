class RemoveIndexOfTBaogaoProgram < ActiveRecord::Migration[5.0]
  def change
    remove_index :t_baogao_programs,:name
  end
end
