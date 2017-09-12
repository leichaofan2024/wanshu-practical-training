class TRecordInfo < ApplicationRecord
    self.table_name = 't_record_info'
    belongs_to :t_work_info
    belongs_to :t_duan_info, class_name: 'TDuanInfo', foreign_key: 'F_duan_uuid'
    belongs_to :t_user_info, foreign_key: 'F_user_uuid'
    belongs_to :t_station_info, foreign_key: 'F_station_uuid'
    belongs_to :t_team_info, foreign_key: 'F_team_uuid'
    has_many :t_record_detail_infoes, class_name: 'TRecordDetailInfo', foreign_key: 'F_record_uuid'
    has_many :t_program_infoes, through: :t_record_detail_infoes, source: :t_program_info
end
