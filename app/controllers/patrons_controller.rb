class PatronsController < ApplicationController
  before_filter :require_user
  before_action :set_patron, only: [:edit, :update]

  def new
    @patron = Patron.new
  end

  def create
    @patron = Patron.new(patron_params)

    if @patron.save
      redirect_to new_patron_path, notice: 'A new patron is created!'
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    if @patron.update(patron_params)
      redirect_to new_patron_path, notice: 'Your patron was updated!'
    else
      render :edit
    end
  end

  private

  def patron_params
    params.require(:patron).permit(:email_address, :name, :ar_code, :address1, :city, :state, :zip1)
  end

  def set_patron
    @patron = Patron.find params[:id]
  end
end