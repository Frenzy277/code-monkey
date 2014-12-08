class MentoringSessionsController < ApplicationController
  before_action :require_user

  def index
    @mentoring_sessions = current_user.mentor_sessions
  end

  def create
    skill = Skill.find(params[:skill_id])
    mentoring_session = skill.mentoring_sessions.build(mentee: current_user, mentor: skill.mentor, support: params[:support], position: set_new_position(skill))
    if mentoring_session.save
      flash[:success] = "Great, you have signed up for #{mentoring_session.support} from #{skill.mentor.full_name}. Check your dashboard 'Signed for' table for status."
    else
      flash[:danger] = "You are not allowed to do that."
    end
    
    redirect_to dashboard_url
  end

private

  def set_new_position(skill)
    skill.mentor_sessions_total + 1
  end

end