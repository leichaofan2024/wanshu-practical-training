class TBaogaoProgramsController < ApplicationController
  def new
    @t_baogao_program = TBaogaoProgram.new
  end

  def create
    @t_baogao_program = TBaogaoProgram.new(t_baogao_program_params)
    if @t_baogao_program.save
      redirect_to baogao_path
    else
      render :new
    end
  end

  def edit

  end

  private

  def t_baogao_program_params
    params.require(:t_baogao_program).permit(:name,:program_one,:program_two,:program_three,:program_four,:program_five,:program_six,:program_seven,:program_eight)
  end

end
