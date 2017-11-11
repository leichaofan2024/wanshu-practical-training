class Browse < ApplicationRecord
  belongs_to :user,:foreign_key => "user_id"
  belongs_to :call_board,:foreign_key => "call_board_id"
end
