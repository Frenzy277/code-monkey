class MentoringSession < ActiveRecord::Base
  belongs_to :skill
  belongs_to :mentee, class_name: "User"
  belongs_to :mentor, class_name: "User"

  validates_presence_of :status, :skill, :mentee, :support
  validates_numericality_of :position, only_integer: true
  validates_inclusion_of :support, within: %w(mentoring code\ review)

  delegate :mentor, to: :skill

  def mentor_short_name
    "#{mentor.first_name} #{mentor.last_name[0].upcase}."
  end

  def feedback_submitted?
    skill.feedbacks.where(giver: self.mentee).any?
  end
end