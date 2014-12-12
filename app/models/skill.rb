class Skill < ActiveRecord::Base
  belongs_to :mentor, class_name: "User"
  belongs_to :language
  has_many :mentoring_sessions, -> { order(:position) }
  has_many :feedbacks, -> { order(created_at: :desc) },
                       through: :mentoring_sessions

  validates_presence_of :mentor, :language, :experience

  def total_feedbacks
    feedbacks.count == 0 ? "none" : feedbacks.count
  end

  def mentor_sessions_total
    mentor.mentor_sessions_not_completed.count
  end
end