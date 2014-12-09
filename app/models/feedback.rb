class Feedback < ActiveRecord::Base
  belongs_to :giver, class_name: "User"
  belongs_to :mentoring_session

  validates_presence_of :giver, :mentoring_session, :content

  def language_name
    mentoring_session.skill.language.name
  end
end