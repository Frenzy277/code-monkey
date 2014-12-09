class FeedbacksController < ApplicationController
  before_action :require_user

  def new
    @mentoring_session = MentoringSession.find(params[:mentoring_session_id])
    @feedback = @mentoring_session.feedbacks.build

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @mentoring_session = MentoringSession.find(params[:mentoring_session_id])
    @feedback = @mentoring_session.feedbacks.build(feedback_params)
    
    respond_to do |format|
      format.html do
        if @feedback.save
          flash[:success] = "xxx"
          redirect_to dashboard_url
        else
          render :new
        end
      end

      format.js do
        flash.now[:danger] = "xxx" unless @feedback.save
      end
    end
  end

private
  
  def feedback_params    
    params.require(:feedback).permit(:content, :recommended).merge!(giver: current_user)
  end
end