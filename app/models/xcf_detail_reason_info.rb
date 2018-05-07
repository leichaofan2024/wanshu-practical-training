class XcfDetailReasonInfo < ApplicationRecord
  belongs_to :xcf_record_detail_infos, class_name: "XcfRecordDetailInfo", foreign_key: "F_record_detail_uuid"
  belongs_to :xcf_reason_infos, class_name: "XcfReasonInfo", foreign_key: "F_reason_id"
end
