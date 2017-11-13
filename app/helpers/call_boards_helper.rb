module CallBoardsHelper

  def if_browsed?(current_user,c)
    call_board_ids = current_user.browses.pluck(:call_board_id)
    unless call_board_ids.include?(c.id)
      "(未读)"
    end
  end
end
