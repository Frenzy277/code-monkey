class QueueItemsController < ApplicationController
  before_action :require_user

  def create
    skill = Skill.find(params[:skill_id])

    queue_item = skill.queue_items.build(mentee: current_user, support: params[:support], position: 1)
    if queue_item.save
      flash[:success] = "Great, you have signed up for #{queue_item.support} from #{skill.mentor.full_name}. Check your dashboard 'Signed for' table for status."
    else
      flash[:danger] = "You are not allowed to do that."
    end
    redirect_to dashboard_url
  end
end