class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.integer :message_id
      t.string :message_type
      t.integer :complaint_id
      t.string :statement
      t.timestamp :dateTime

      t.timestamps
    end
  end
end
