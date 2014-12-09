class MentoringSessionsController < ApplicationController
  before_action :require_user

  def index
    @mentoring_sessions = current_user.mentor_sessions_not_completed
  end

  def create
    skill = Skill.find(params[:skill_id])
    unless current_user == skill.mentor
      mentoring_session = skill.mentoring_sessions.build(mentee: current_user, mentor: skill.mentor, support: params[:support], position: set_new_position(skill))
      if mentoring_session.save
        flash[:success] = "Great, you have signed up for #{mentoring_session.support} from #{skill.mentor.full_name}. Check your dashboard 'Signed for' table for status."
      else
        flash[:danger] = "You are not allowed to do that."
      end
    end
    
    redirect_to dashboard_url
  end

  def update_sessions
    if params[:mentoring_sessions]
      begin
        update_mentoring_sessions

        current_user.normalize_mentoring_sessions
      rescue ActiveRecord::RecordInvalid
        flash[:danger] = "xxx"
      end
    end

    redirect_to mentoring_sessions_url
  end

private

  def set_new_position(skill)
    skill.mentor_sessions_total + 1
  end

  def update_mentoring_sessions
    ActiveRecord::Base.transaction do
      params[:mentoring_sessions].each do |ms_data|
        mentoring_session = MentoringSession.find(ms_data[:id])
        if !mentoring_session.completed? && ms_data[:status] == "completed"
          mentoring_session.credit_balance_operations!
          mentoring_session.code_helped_operations!
        end

        mentoring_session.update!(position: ms_data[:position], status: ms_data[:status]) if mentoring_session.mentor == current_user
      end
    end
  end 

end