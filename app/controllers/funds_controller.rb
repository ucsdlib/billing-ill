class FundsController < ApplicationController

  def new
    @fund = Fund.new
  end
end