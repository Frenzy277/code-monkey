class MentoringSession < ActiveRecord::Base
  belongs_to :skill
  belongs_to :mentee, class_name: "User"
  belongs_to :mentor, class_name: "User"
  has_many :feedbacks

  validates_presence_of :status, :skill, :mentee, :support
  validates_numericality_of :position, only_integer: true, unless: :completed?
  validates_inclusion_of :support, within: %w(mentoring code\ review)
  validates_inclusion_of :status, within: %w(pending accepted rejected completed)
  validates_absence_of :position, if: :completed?

  delegate :short_name, to: :mentor, prefix: :mentor

  def feedback_submitted?
    feedbacks.where(giver: mentee).any?
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