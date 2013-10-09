class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :student_id_card
      t.integer :semester_no
      t.string :subject_name

      t.timestamps
    end
  end
end
