class XcfReasonInfo < ApplicationRecord
  has_many :xcf_detail_reason_infoes, class_name: "XcfDetailReasonInfo", foreign_key: "F_reason_id"
  has_many :xcf_record_detail_infoes, class_name: "XcfRecordDetailInfo",:through => :xcf_detail_reason_infoes
  belongs_to :xcf_reason_type_infos, class_name: "XcfReasonTypeInfo", foreign_key: "F_reason_type_id"
end
