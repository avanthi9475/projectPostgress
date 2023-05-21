class RemoveOfficerIdFromComplaints < ActiveRecord::Migration[6.1]
  def change
    remove_column :complaints, :officer_id
  end
end
