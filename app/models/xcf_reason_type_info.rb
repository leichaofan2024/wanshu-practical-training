class XcfReasonTypeInfo < ApplicationRecord
  has_many :xcf_reason_infoes, class_name: "xcf_reason_info",foreign_key: "F_reason_type_id"
end
