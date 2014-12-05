class Language < ActiveRecord::Base
  has_many :skills

  validates_presence_of :name
end