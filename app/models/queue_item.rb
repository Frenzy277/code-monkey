class QueueItem < ActiveRecord::Base
  belongs_to :skill
  belongs_to :user

  validates_presence_of :status, :position, :skill, :user
  validates_numericality_of :position, only_integer: true
end