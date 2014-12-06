class SkillsController < ApplicationController
  before_action :require_user

  def new
    @skill = Skill.new
  end

  def create
    @skill = current_user.skills.build(skill_params)
    
    if @skill.save
      flash[:success] = "xxx"
      redirect_to dashboard_url
    else
      render :new
    end
  end

private
  
  def skill_params
    params.require(:skill).permit(:language_id, :description, :experience)
  end
end