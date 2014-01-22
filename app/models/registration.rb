class Registration < ActiveRecord::Base
  belongs_to :subjects
  belongs_to :semesters
  belongs_to :students

  validates :student_id, :presence => true
  #validates :semester_id, :presence => true
  validates_uniqueness_of :semester_id, :scope => [:student_id, :subject_id]

  SEMESTER_TYPES = []
  semester = Semester.all
  semester.each do |semester|
    SEMESTER_TYPES.push(semester.id)
  end

  before_save :eligibility_test

  before_create :is_subject_selected


  def is_subject_selected
    if (subject_id.blank?)
      errors[:base] << "Please select subject/s"
      return false
    else
      return true
    end
  end

  def save_registration(params, student)
    err = false
    previous_subjects = []

    register = Registration.where(:semester_id => self.semester_id, :student_id => student)
    previous_subjects = register.collect { |x| "#{x.subject_id}" }

    present_subjects = params[:subject_id]

    if (present_subjects.blank?)
      present_subjects = []
    end

    unless present_subjects.blank?
      subjects_to_add = present_subjects - previous_subjects
    else
      subjects_to_add = []
    end

    unless previous_subjects.blank?
      subjects_to_delete = previous_subjects - present_subjects
    else
      subjects_to_delete = []
    end

    unless subjects_to_delete.blank?
      subjects_to_delete.each do |reg|
        Registration.destroy_all(:student_id => student, :semester_id => params[:semester_id], :subject_id => reg)
      end
    end

    unless subjects_to_add.blank?
      subjects_to_add.each do |reg|
        @registration = Registration.new({semester_id: params[:semester_id], student_id: student, subject_id: reg})
        unless @registration.save
          err = true
        end
      end
    end
    err
  end

  private
  def eligibility_test
    @register = Registration.all
    @register.each do |i|
      if i.subject_id == subject_id
        if i.semester_id != semester_id
          if i.student_id == student_id
            errors[:base] << "subject already taken to semester #{i.semester_id}"
            return false
          end
        end
      end
    end
  end
end