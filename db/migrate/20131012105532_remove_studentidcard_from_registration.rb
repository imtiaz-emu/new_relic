class RemoveStudentidcardFromRegistration < ActiveRecord::Migration
  def change
    remove_column :registrations, :student_id_card, :string
  end
end
