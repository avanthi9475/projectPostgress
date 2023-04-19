json.extract! login, :id, :email, :password, :role, :logouttime, :created_at, :updated_at
json.url login_url(login, format: :json)
