module RegistrationsHelper
  def get_student_name(std_id)
    Student.find(std_id).name
  end
end
