class QueueItemsController < ApplicationController
  before_action :require_user

  def create
    skill = Skill.find(params[:skill_id])

    QueueItem.create(skill: skill, user: current_user, support: params[:support], position: 1)
    redirect_to dashboard_url
  end
end