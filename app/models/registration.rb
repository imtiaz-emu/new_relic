class Registration < ActiveRecord::Base
  has_many :subjects
  has_many :semesters

  validates :student_id_card, :presence => true
  validates :semester_no, :presence => true
  validates_uniqueness_of :semester_no, :scope => [:student_id_card, :subject_name]

  SEMESTER_TYPES = []
  semester = Semester.all
  semester.each do |semester|
    SEMESTER_TYPES.push(semester.semester_no)
  end

  before_save :eligibility_test

  before_create :is_subject_selected


  def is_subject_selected
    if (subject_name.blank?)
      errors[:base] << "Please select subject/s"
      return false
    else
      return true
    end
  end

  private
  def eligibility_test
    @register = Registration.all
    @register.each do |i|
      if i.subject_name == subject_name
        if i.semester_no != semester_no
          if i.student_id_card == student_id_card
            errors[:base] << "subject already taken to semester #{i.semester_no}"
            return false
          end
        end
      end
    end
  end

end
