class PagesController < ApplicationController
  before_action :require_user, only: [:dashboard]

  def front
    if logged_in?
      redirect_to dashboard_url
    else
      render :front, layout: "no_header"
    end
  end

  def dashboard
    @languages = Language.all
  end
end