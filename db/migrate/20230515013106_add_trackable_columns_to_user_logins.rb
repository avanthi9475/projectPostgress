class AddTrackableColumnsToUserLogins < ActiveRecord::Migration[6.1]
  def change
    add_column :user_logins, :sign_in_count, :integer
    add_column :user_logins, :current_sign_in_at, :datetime
    add_column :user_logins, :last_sign_in_at, :datetime
    add_column :user_logins, :current_sign_in_ip, :string
    add_column :user_logins, :last_sign_in_ip, :string
  end
end
