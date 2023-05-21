class AddNewColumnIsHeadToOfficersComplaints < ActiveRecord::Migration[6.1]
  def change
    add_column :officers_complaints, :IsHead, :string
  end
end
