class CreateTBaogaoInputs < ActiveRecord::Migration[5.0]
  def change
    create_table :t_baogao_inputs do |t|
      t.string         :title
      t.text           :content
      t.json           :baogao_attachment
      t.datetime       :baogao_time
      t.timestamps
    end
  end
end
