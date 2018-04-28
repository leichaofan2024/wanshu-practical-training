class XcfRecordDetailInfo < ApplicationRecord
  belongs_to :xcf_record_info,class_name: "XcfRecordInfo", foreign_key: "F_record_uuid"
  belongs_to :xcf_program_info, class_name: "XcfProgramInfo", foreign_key: "F_program_id"
  has_many :xcf_detail_reason_infoes, class_name: "XcfDetailReasonInfo", foreign_key: "F_record_detail_uuid"
  has_many :xcf_reason_infoes,class_name: "xcf_reason_info", through: :xcf_detail_reason_infoes

end
