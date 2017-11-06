class CallBoard < ApplicationRecord
  mount_uploaders :call_board_attachments,CallBoardAttachmentUploader 
end
