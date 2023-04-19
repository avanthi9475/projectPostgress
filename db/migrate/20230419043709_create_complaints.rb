class CreateComplaints < ActiveRecord::Migration[6.1]
  def change
    create_table :complaints do |t|
      t.belongs_to :user, unique: true , foreign_key: true
      t.belongs_to :officer, unique: true , foreign_key: true
      t.text :statement
      t.string :location
      t.timestamp :dateTime, null: false

      t.timestamps
    end
  end
end
