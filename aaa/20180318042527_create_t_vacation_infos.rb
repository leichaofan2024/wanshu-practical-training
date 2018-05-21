class CreateTVacationInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :t_vacation_infos do |t|
      t.string         :F_id
      t.datetime       :begin_time
      t.datetime       :end_time
      t.string         :F_type
      t.timestamps
    end
  end
end
