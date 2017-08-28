class TReasonInfo < ApplicationRecord
  self.table_name = "t_reason_info"
  has_many :t_detail_reason_infoes,:class_name => "TDetailReasonInfo", :foreign_key => "F_reason_id"





  scope :reason_hot, -> {map{|r| [r.F_name,r.t_detail_reason_infoes.count]}.sort_by{|a| a.second}.map{|b| b.first}.reverse}

end
