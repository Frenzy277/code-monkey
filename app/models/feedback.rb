class Feedback < ActiveRecord::Base
  belongs_to :giver, class_name: "User"
  belongs_to :skill

  validates_presence_of :giver, :skill, :content, :recommended
end