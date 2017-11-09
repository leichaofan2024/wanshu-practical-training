class CallBoard < ApplicationRecord
  mount_uploaders :call_board_attachments,CallBoardAttachmentUploader


  belongs_to :user,:foreign_key => "user_id"
end
