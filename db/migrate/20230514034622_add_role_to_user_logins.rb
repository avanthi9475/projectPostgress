class AddRoleToUserLogins < ActiveRecord::Migration[6.1]
  def change
    add_column :user_logins, :role, :string
  end
end
