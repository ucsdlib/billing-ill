# encoding: utf-8
#---
# @author hweng@ucsd.edu
#---

class FundsController < ApplicationController
  before_action :require_user
  before_action :set_fund, only: [:edit, :update]

  def index
    @total_count = Fund.count
    @funds = all_items(Fund)
  end

  def new
    @fund = Fund.new
  end

  def create
    @fund = Fund.new(fund_params)

    if @fund.save
      redirect_to new_fund_path, notice: 'A new fund is created!'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @fund.update(fund_params)
      redirect_to new_fund_path, notice: 'Your fund was updated!'
    else
      render :edit
    end
  end

  private

  def fund_params
    params.require(:fund).permit(:program_code, :org_code, :index_code, :fund_code, :description)
  end

  def set_fund
    @fund = Fund.find params[:id]
  end
end
