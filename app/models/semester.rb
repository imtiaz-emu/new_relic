class Semester < ActiveRecord::Base
  has_and_belongs_to_many :subjects
  has_many :registration, :dependent => :destroy

  validates :semester_no, :presence => true, :uniqueness => true
end
