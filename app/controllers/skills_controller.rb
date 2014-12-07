class SkillsController < ApplicationController
  before_action :require_user

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params.merge(mentor: current_user))
    
    if @skill.save
      flash[:success] = "Congratulations, you became a new mentor!"
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