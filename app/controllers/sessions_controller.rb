class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  layout "no_header"

  def new
    redirect_to dashboard_url if logged_in?
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have logged in."
      redirect_to dashboard_url
    else
      flash.now[:danger] = "Invalid email or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have logged out."
    redirect_to root_url
  end
end