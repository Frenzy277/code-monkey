class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :skills
  has_many :feedbacks, foreign_key: "giver_id"
  has_many :queue_items, -> { order(:position) }, foreign_key: "mentee_id"
  has_many :mentor_queue_items, class_name: "QueueItem", foreign_key: "mentor_id"
  before_save { |user| user.email = user.email.downcase }

  validates :first_name, :last_name, :email, :password, :balance, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]{2,}\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  
  validates :password, length: { minimum: 6 }
  
  def full_name
    [first_name, last_name].join(" ")
  end
  
end