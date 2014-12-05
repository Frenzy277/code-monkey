class UsersController < ApplicationController

  layout "no_header"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "You have successfully signed up, please log in."
      redirect_to sign_in_url
    else
      render :new
    end    
  end

private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end