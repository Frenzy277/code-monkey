class QueueItemsController < ApplicationController
  before_action :require_user

  def create
    skill = Skill.find(params[:skill_id])

    queue_item = QueueItem.create(skill: skill, mentee: current_user, support: params[:support], position: 1)
    flash[:success] = "Great, you have signed up for #{queue_item.support} from #{skill.mentor.full_name}. Check your dashboard 'Signed for' table for status."
    redirect_to dashboard_url
  end
end