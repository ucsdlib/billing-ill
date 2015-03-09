#---
# by hweng@ucsd.edu
#---

class RechargesController < ApplicationController
  before_action :set_recharge, only: [:edit, :update]
  before_action :set_index_list, only: [:new, :create, :edit, :update]

  def index
    @total_count = Recharge.count
    result_arr = Recharge.order(:created_at)
    @recharges = result_arr.page(params[:page]) if !result_arr.blank?
  end

  def new
    @recharge = Recharge.new
  end

  def create
    @recharge = Recharge.new(recharge_params)

    if @recharge.save
      redirect_to root_path, notice: 'A new recharge is created!'
    else
      render :new
    end
  end

  def edit
    @selected_index = @recharge.fund_id
    @selected_status = @recharge.status
  end

  def update

    if @recharge.update(recharge_params)
      flash[:notice] = "Your recharge was updated"
      redirect_to root_path
    else
      render :edit
    end
  end

  def search
      @total_count = Recharge.count
      result_arr = Recharge.search_by_index_code(params[:search_term])
      @search_result = index_result_arr.page(params[:page]) if !result_arr.blank?
  end

  def process_batch
    @current_batch_count = Recharge.pending_status_count
    result_arr = Recharge.search_all_pending_status
    @current_batch_result = result_arr.page(params[:page]) if !result_arr.blank?
  end

  

  private

  def recharge_params
    params.require(:recharge).permit(:number_copies, :charge, :status, :notes, :fund_id)
  end

  def set_recharge
    @recharge = Recharge.find params[:id]
  end

  def set_index_list
    @index_list = Fund.all.map{|fund|[fund.index_code,fund.id]}
  end
end