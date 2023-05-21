class CreateCrimeFirs < ActiveRecord::Migration[6.1]
  def change
    create_table :crime_firs do |t|
      t.integer :user_id
      t.belongs_to :complaint, unique: true, foreign_key: true
      t.integer :under_section
      t.string :crime_category
      t.timestamp :dateTime_of_crime

      t.timestamps
    end
  end
end
