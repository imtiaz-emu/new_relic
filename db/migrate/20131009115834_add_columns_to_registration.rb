class AddColumnsToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :subject_id, :integer
    add_column :registrations, :semester_id, :integer
  end
end
