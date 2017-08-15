class TRecordInfo < ApplicationRecord
  self.table_name = "t_record_info"
  belongs_to :t_work_info
  

end
