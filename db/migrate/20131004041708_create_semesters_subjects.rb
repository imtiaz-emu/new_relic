class CreateSemestersSubjects < ActiveRecord::Migration
  def up
    create_table :semesters_subjects, :id => false do |t|
      t.integer :semester_id
      t.integer :subject_id
    end
  end

  def down
    drop_table :semesters_subjects
  end
end
