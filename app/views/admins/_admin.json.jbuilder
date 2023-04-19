json.extract! admin, :id, :email, :name, :age, :location, :created_at, :updated_at
json.url admin_url(admin, format: :json)
