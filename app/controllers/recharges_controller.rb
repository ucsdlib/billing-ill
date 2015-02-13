#---
# by hweng@ucsd.edu
#---

class RechargesController < ApplicationController
  before_action :set_recharge, only: [:edit, :update]

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
    
  end

  def update
    if @recharge.update(recharge_params)
      flash[:notice] = "Your recharge was updated"
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def recharge_params
    params.require(:recharge).permit(:number_copies, :charge, :status, :notes, :fund_id)
  end

  def set_recharge
    @recharge = Recharge.find_by params[:id]
  end
end