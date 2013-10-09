class Semester < ActiveRecord::Base
  has_and_belongs_to_many :subjects
  belongs_to :registration

  validates :semester_no, :presence => true, :uniqueness => true
end
