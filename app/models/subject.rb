class Subject < ActiveRecord::Base
  has_and_belongs_to_many :semesters

  has_many :registration, :dependent => :destroy

  validates :subject_name, :presence => true, :uniqueness => true

  before_save :is_semester_selected


  def is_semester_selected
    if (semester_ids.blank?)
      errors[:base] << "Please select atleast one semester"
      return false
    else
      return true
    end
  end
end
