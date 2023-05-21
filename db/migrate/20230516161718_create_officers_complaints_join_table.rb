class CreateOfficersComplaintsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :officers_complaints, id: false do |t|
      t.references :officer
      t.references :complaint
    end
  end
end
