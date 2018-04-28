class TWorkInfo < ApplicationRecord
    self.table_name = 't_work_info'
    has_many :t_user_infoes,:class_name => "TUserInfo",:foreign_key => "F_work_uuid"
    has_many :t_user_info_copies
    has_many :t_user_info_copy_copies
    has_many :t_record_infoes
    has_many :xcf_user_infoes, :class_name => "XcfUserInfo", :foreign_key => "F_work_uuid"
end
