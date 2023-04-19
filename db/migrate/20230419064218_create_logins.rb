class CreateLogins < ActiveRecord::Migration[6.1]
  def change
    create_table :logins do |t|
      t.string :email
      t.string :password
      t.string :role
      t.timestamp :logouttime, null: false, default: -> { 'NOW()' }

      t.timestamps
    end
  end
end
