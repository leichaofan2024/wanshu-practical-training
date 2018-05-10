class FaqsController < ApplicationController
 def index
   @faqs = Faq.all
 end

  def new
    @faq = Faq.new
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      redirect_to faqs_path
    else
      render :new
      flash[:warning] = "输入框不能为空!"
    end
  end

  def edit
    @faq = Faq.find(params[:id])

  end

  def update
    @faq  = Faq.find(params[:id])
    if @faq.update(faq_params)
      redirect_to baogao_path
    else
      render :edit
      flash[:warning] = "输入框不能为空"
    end
  end

  def destroy
    @faq = Faq.find(params[:id])
    @faq.destroy
    redirect_to faqs_path
  end

  private

  def faq_params
    params.require(:faq).permit(:title,:content,{:faq_attachment => []} )
  end
end
