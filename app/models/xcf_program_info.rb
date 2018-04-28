class XcfProgramInfo < ApplicationRecord
  has_many :xcf_record_detail_infoes, class_name: "XcfRecordDetailInfo",foreign_key: "F_program_id"
  has_many :xcf_record_infoes, class_name: "XcfRecordInfo",through: :xcf_record_detail_infoes
  belongs_to :xcf_program_type_info, class_name: "XcfProgramTypeInfo", foreign_key: "F_type_id"
end
