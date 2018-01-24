class CallBoard < ApplicationRecord
  mount_uploaders :call_board_attachments,CallBoardAttachmentUploader
  has_many :browses,:foreign_key => "call_board_id"

  belongs_to :user,:foreign_key => "user_id"
end
