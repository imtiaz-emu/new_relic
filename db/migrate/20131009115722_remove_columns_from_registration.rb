class RemoveColumnsFromRegistration < ActiveRecord::Migration
  def change
    remove_column :registrations, :subject_name, :string
    remove_column :registrations, :semester_no, :integer
  end
end
