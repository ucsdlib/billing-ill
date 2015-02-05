#---
# by hweng@ucsd.edu
#---

class FundsController < ApplicationController
  before_action :set_fund, only: [:edit, :update]

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

  def edit
    
  end

  def update
    if @fund.update(fund_params)
      flash[:notice] = "Your fund was updated"
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def fund_params
    params.require(:fund).permit(:program_code, :org_code, :index_code, :fund_code)
  end

  def set_fund
    @fund = Fund.find_by params[:id]
  end
end