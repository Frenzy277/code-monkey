class Language < ActiveRecord::Base
  has_many :skills, -> { order(helped_total: :desc) }

  validates_presence_of :name
end