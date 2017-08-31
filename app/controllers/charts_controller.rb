class ChartsController < ApplicationController
  def names
    result = {}
    TDuanInfo.all.map do |d|
      if d.t_record_infoes.count.present?
        result[d.F_name] = d.t_record_infoes.count
      end
    end
    render json: [{name: 'F_name', data: result}]
  end
end
