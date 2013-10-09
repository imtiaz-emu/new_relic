class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :student_card_number
      t.integer :semester_number

      t.timestamps
    end
  end
end
