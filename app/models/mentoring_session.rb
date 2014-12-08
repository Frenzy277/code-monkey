class MentoringSession < ActiveRecord::Base
  belongs_to :skill
  belongs_to :mentee, class_name: "User"
  belongs_to :mentor, class_name: "User"

  validates_presence_of :status, :skill, :mentee, :support
  validates_numericality_of :position, only_integer: true
  validates_inclusion_of :support, within: %w(mentoring code\ review)
  validates_inclusion_of :status, within: %w(pending accepted rejected completed)

  def mentor_short_name
    "#{mentor.first_name} #{mentor.last_name[0].upcase}."
  end

  def feedback_submitted?
    skill.feedbacks.where(giver: mentee).any?
  end

  def credit_balance_operations!
    mentor.increment!(:balance)
    mentee.decrement!(:balance)
  end

  def code_helped_operations!
    skill.increment!(:helped_total)
  end

  def completed?
    status == "completed"
  end
end