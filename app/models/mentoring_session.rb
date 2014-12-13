class MentoringSession < ActiveRecord::Base
  belongs_to :skill
  belongs_to :mentee, class_name: "User"
  belongs_to :mentor, class_name: "User"
  has_many :feedbacks

  validates_presence_of :status, :skill, :mentee, :support
  validates_numericality_of :position, only_integer: true, unless: :completed?
  validates_inclusion_of :support, within: %w(mentoring code\ review)
  VALID_STATUS = %w(pending accepted rejected completed)
  validates_inclusion_of :status, within: VALID_STATUS
  validates_absence_of :position, if: :completed?

  scope :not_completed, -> { where.not(status: "completed") }

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

  def pending?
    status == "pending"
  end

  def accepted?
    status == "accepted"
  end

  def rejected?
    status == "rejected"
  end
end