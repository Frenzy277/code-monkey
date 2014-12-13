module ApplicationHelper

  def status_options
    MentoringSession::VALID_STATUS
  end

  def secondary_status(ms)
    if ms.pending?
      "waiting on"
    elsif ms.accepted?
      link_to "contact mentor"
    elsif ms.rejected?
      "-----"
    elsif ms.completed? && ms.feedback_submitted?
      "submitted"
    else
      link_to "feedback", new_mentoring_session_feedback_path(ms), remote: true
    end
  end
end
