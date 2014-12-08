class Feedback < ActiveRecord::Base
  belongs_to :giver, class_name: "User"
  belongs_to :mentoring_session

  validates_presence_of :giver, :mentoring_session, :content, :recommended
end