module TDuanInfoesHelper
  def render_duan_team_count(duan)
    sum = 0
    duan.t_station_infoes.each do |s|
      sum+= s.t_team_infoes.count
    end
    return sum
  end

end
