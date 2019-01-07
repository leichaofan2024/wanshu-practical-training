class AddColumnYearToTBaogaoProgram < ActiveRecord::Migration[5.0]
  def change
  	add_column :t_baogao_programs,:year,:integer
  end
end
