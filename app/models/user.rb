class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :skills, foreign_key: "mentor_id"
  has_many :feedbacks, foreign_key: "giver_id"
  has_many :mentee_sessions, class_name: "MentoringSession",
                             foreign_key: "mentee_id"
  has_many :mentor_sessions, -> { order(:position) },
                             class_name: "MentoringSession",
                             foreign_key: "mentor_id"

  before_save { |user| user.email = user.email.downcase }

  validates_presence_of :first_name, :last_name, :email, :password, :balance
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,}\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  def full_name
    [first_name, last_name].join(" ")
  end

  def short_name
    [first_name, last_name[0].upcase].join(" ") << "."
  end

  def normalize_mentoring_sessions
    mentor_sessions.not_completed.each_with_index do |ms, position|
      ms.update_column(:position, position + 1)
    end
  end

  def mentor?(obj)
    obj.mentor == self
  end

  def has_any_skills?
    skills.any?
  end
end