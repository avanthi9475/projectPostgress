class AddColumnToUserLogins < ActiveRecord::Migration[6.1]
  def change
    add_column :user_logins, :confirmation_token, :string
    add_column :user_logins, :confirmed_at, :datetime
    add_column :user_logins, :confirmation_sent_at, :datetime
    add_column :user_logins, :unconfirmed_email, :string # Only if using reconfirmable

    add_index :user_logins, :confirmation_token,   unique: true
  end
end
