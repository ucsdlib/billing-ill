# encoding: utf-8
class UsersController < ApplicationController

  def new
    @user = User.new
  end
end