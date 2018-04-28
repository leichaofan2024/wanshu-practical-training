class XcfRecordInfo < ApplicationRecord
  belongs_to :xcf_user_info, class_name: "XcfUserInfo", :foreign_key => "F_user_uuid"
  has_many :xcf_record_detail_infoes,class_name: "XcfRecordDetailInfo", :foreign_key => "F_record_uuid"
  has_many :xcf_program_infoes, class_name: "XcfProgramInfo",through: :xcf_record_detail_infoes
end
