class CreateBrowses < ActiveRecord::Migration[5.0]
  def change
    create_table :browses do |t|
      t.integer :user_id
      t.integer :call_board_id
      t.timestamps
    end
  end
end
