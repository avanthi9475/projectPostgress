class CreateOfficers < ActiveRecord::Migration[6.1]
  def change
    create_table :officers do |t|
      t.string :email
      t.string :name
      t.integer :age
      t.string :location
      t.string :role

      t.timestamps
    end
  end
end
