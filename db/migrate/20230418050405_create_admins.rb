class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins do |t|
      t.string :email
      t.string :name
      t.integer :age
      t.string :location

      t.timestamps
    end
  end
end
