class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.inheritance_column = "_type"


  #机构人数：

  def employee_count
    t = self.t_user_infoes.map{|u| u.F_id}.uniq.count
    return t
  end

end
