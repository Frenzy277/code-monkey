class PagesController < ApplicationController
  
  def front
    render :front, layout: "no_header"
  end

  def dashboard
  end
end