class TBaogaoInput < ApplicationRecord
  mount_uploaders :baogao_attachment, BaogaoAttachmentUploader
end
