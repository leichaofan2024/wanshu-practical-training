class AddCallBoardAttachmentsToCallBoard < ActiveRecord::Migration[5.0]
  def change
    add_column :call_boards, :call_board_attachments, :string
  end
end
