class Skill < ActiveRecord::Base
  belongs_to :mentor, class_name: "User", foreign_key: "user_id"
  belongs_to :language

  validates_presence_of :mentor, :language, :experience
end