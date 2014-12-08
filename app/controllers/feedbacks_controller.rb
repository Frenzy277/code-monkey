class FeedbacksController < ApplicationController
  before_action :require_user

  def new
    @mentoring_session = MentoringSession.find(params[:mentoring_session_id])

    respond_to do |format|
      format.html
      format.js
    end
  end
end