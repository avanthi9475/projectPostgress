json.extract! complaint, :id, :user_id, :officer_id, :statement, :location, :dateTime, :created_at, :updated_at
json.url complaint_url(complaint, format: :json)
