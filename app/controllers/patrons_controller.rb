#---
# @author hweng@ucsd.edu
#---

class PatronsController < ApplicationController
  before_filter :require_user
  before_action :set_patron, only: [:edit, :update]
  before_action :set_country_list, only: [:new, :create, :edit, :update]
  
   def index
    @total_count = Patron.count
    @patrons = get_all_items(Patron)
  end

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
    @selected_country = @patron.country_code
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
    params.require(:patron).permit(:email_address, :name, :ar_code, :address1, :address2, :address3, :address4, :city, :state, :zip1, :zip2, :country_code)
  end

  def set_patron
    @patron = Patron.find params[:id]
  end

  def set_country_list
    @country_list = []
    COUNTRIES.each do |country|
      @country_list << [country[:term], country[:id]]
    end
  end

end