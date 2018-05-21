class CreateTBaogaoPrograms < ActiveRecord::Migration[5.0]
  def change
    create_table :t_baogao_programs do |t|
      t.string    :name
      t.string    :program_one
      t.string    :program_two
      t.string    :program_three
      t.string    :program_four
      t.string    :program_five
      t.string    :program_six
      t.string    :program_seven
      t.string    :program_eight
      t.timestamps

    end
    add_index :t_baogao_programs, :name ,unique: true 
  end
end
