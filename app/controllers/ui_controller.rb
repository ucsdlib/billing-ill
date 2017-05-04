# encoding: utf-8
class UiController < ApplicationController
  before_action do
    redirect_to :root if Rails.env.production?
  end
  before_action :require_user

  layout 'application'

  def index; end
end
