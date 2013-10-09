class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.integer :semester_no

      t.timestamps
    end
  end
end
