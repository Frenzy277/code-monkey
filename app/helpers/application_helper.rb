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

  def secondary_status(ms)
    if ms.status == "pending"
      "waiting on"
    elsif ms.status == "accepted"
      link_to "contact mentor"
    elsif ms.status == "rejected"
      "TBD"
    elsif ms.status == "completed" && ms.feedback_submitted?
      "submitted"
    else
      link_to "feedback", '', data: { toggle: "modal", target: "#feedbackFormModal"}      
    end

  end

end
