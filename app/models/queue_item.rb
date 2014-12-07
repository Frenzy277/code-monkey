class QueueItem < ActiveRecord::Base
  belongs_to :skill
  belongs_to :mentee, class_name: "User", foreign_key: "user_id"

  validates_presence_of :status, :skill, :mentee, :support
  validates_numericality_of :position, only_integer: true
  validates_inclusion_of :support, within: %w(mentoring code\ review)

  delegate :mentor, to: :skill

end