class PagesController < ApplicationController
  before_action :require_user, only: [:dashboard]

  def front
    render :front, layout: "no_header"
  end

  def dashboard
    @languages = Language.all
  end
end