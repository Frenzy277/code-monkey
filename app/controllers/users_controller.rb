class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  
  def new
    @user = User.new
    render :new, layout: "no_header"
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "You have successfully signed up, please log in."
      redirect_to sign_in_url
    else
      render :new, layout: "no_header"
    end    
  end

  def show
    @user = User.find(params[:id])
  end

private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end