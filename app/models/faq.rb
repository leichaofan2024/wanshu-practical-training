class Faq < ApplicationRecord
  mount_uploaders :faq_attachment, FaqAttachmentUploader
end
