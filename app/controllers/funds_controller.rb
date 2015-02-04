class FundsController < ApplicationController

  def new
    @fund = Fund.new
  end

  def create
    @fund = Fund.new(fund_params)

    if @fund.save
      redirect_to root_path, notice: 'A new fund is created!'
    else
      render :new
    end
  end

  private

  def fund_params
    params.require(:fund).permit(:program_code, :org_code, :index_code, :fund_code)
  end
end