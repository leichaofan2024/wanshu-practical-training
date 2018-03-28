class CreateTBaogaoInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :t_baogao_infos do |t|
      t.string    :duan_name
      t.integer   :online_station
      t.integer   :cankao_station
      t.integer   :student_yingkao
      t.integer   :student_shikao
      t.string    :student_dabiao_percent
      t.integer   :student_diaoli
      t.integer   :student_tuixiu
      t.timestamps
    end
  end
end
