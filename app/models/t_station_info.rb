class TStationInfo < ApplicationRecord
  mount_uploaders :image, ImageUploader
  mount_uploaders :attachment, AttachmentUploader
  mount_uploaders :attachment2, Attachment2Uploader
  self.table_name = "t_station_info"


  belongs_to :t_duan_info,:class_name => "TDuanInfo", :foreign_key => "F_duan_uuid"
  has_many :t_team_infoes, :class_name => "TTeamInfo", :foreign_key => "F_station_uuid"
  has_many :t_record_infoes, :foreign_key => "F_station_uuid"
  has_many :t_user_infoes ,:class_name => "TUserInfo" ,:foreign_key => "F_station_uuid"

end
