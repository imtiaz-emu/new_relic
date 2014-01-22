class Search < ActiveRecord::Base
  def registrations
    @registrations ||= find_registers
  end

  private
  def find_registers
    registrations = Registration.order(:student_id)
    if student_card_number.present? and semester_number.present?
      registrations = registrations = registrations.where(semester_id: semester_number, student_id: student_card_number )
    elsif student_card_number.present?
      registrations.where("student_id like ?", "%#{student_card_number}")
    elsif semester_number.present?
      registrations = registrations.where(semester_id: semester_number)
    else
      registrations = nil
    end
  end
end