class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.mentor_queue_items
  end

  def create
    skill = Skill.find(params[:skill_id])
    queue_item = skill.queue_items.build(mentee: current_user, mentor: skill.mentor, support: params[:support], position: set_new_position(skill))
    if queue_item.save
      flash[:success] = "Great, you have signed up for #{queue_item.support} from #{skill.mentor.full_name}. Check your dashboard 'Signed for' table for status."
    else
      flash[:danger] = "You are not allowed to do that."
    end
    
    redirect_to dashboard_url
  end

private

  def set_new_position(skill)
    skill.mentors_queue_total + 1
  end

end