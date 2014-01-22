class AddStudentidToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :student_id, :integer
  end
end
