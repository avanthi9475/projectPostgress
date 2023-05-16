class CreateStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :statuses do |t|
      t.integer :statusable_id
      t.string :statusable_type
      t.string :status

      t.timestamps
    end
  end
end
