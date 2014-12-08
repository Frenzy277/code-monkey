class LanguagesController < ApplicationController
  before_action :require_user, only: [:index]

  def index
    @languages = Language.all
  end

  def show
    @language = Language.find(params[:id])
  end

  def front
    if logged_in?
      redirect_to dashboard_url
    else
      @languages = Language.all
      render :front, layout: "no_header"
    end
  end
end