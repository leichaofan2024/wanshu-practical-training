class Api::Qjsx::DataTransferController < ApiController

  def create_data
    head = request.headers["ws-xcf-api"]
    if head == "75edb54405964a0c8393ce427f5f5d5e"

      render :json => {
        "ret" => 0 ,
        "msg" => "上传成功",
        "data" => ""
      }
    else
      render :json => {
        "ret" => 1,
        "msg" => "token无效",
        "data" => ""
      }
    end
  end

  def data_test
    head = request.headers["ws-xcf-api"]
    if head == "75edb54405964a0c8393ce427f5f5d5e"

      render :json => {
        "ret" => 0,
        "msg" => "连接成功",
        "data" => ""
      }
    else
      render :json => {
        "ret" => 1,
        "msg" => "token无效",
        "data" => ""
      }
    end
  end

end
