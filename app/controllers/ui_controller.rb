class UiController < ApplicationController
  before_filter do
    redirect_to :root if Rails.env.production?
  end
  before_filter :require_user

  layout "application"

  def index
  end
end