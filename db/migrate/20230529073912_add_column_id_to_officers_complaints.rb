class AddColumnIdToOfficersComplaints < ActiveRecord::Migration[6.1]
  def change
    add_column :officers_complaints, :id, :primary_key
  end
end
