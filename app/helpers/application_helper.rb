module ApplicationHelper

  def mentor?
    current_user.skills.any?
  end

  def status_options
    %w(pending accepted rejected completed)
  end

  def short_date(time)
    time.strftime("%m/%d/%Y")
  end

  def secondary_status(qi)
    if qi.status == "pending"
      "waiting on"
    elsif qi.status == "accepted"
      link_to "contact mentor"
    elsif qi.status == "rejected"
      "TBD"
    elsif qi.status == "completed" && qi.feedback_submitted
      "submitted"
    else
      link_to "feedback", '', data: { toggle: "modal", target: "#feedbackFormModal"}      
    end

  end

end
