class Language < ActiveRecord::Base
  has_many :skills, -> { order(helped_total: :desc) }

  validates_presence_of :name


  def total_skills
    skills.count unless skills.count == 0
  end
end