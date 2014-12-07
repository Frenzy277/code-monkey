module ApplicationHelper

  def mentor?
    current_user.skills.any?
  end

end
