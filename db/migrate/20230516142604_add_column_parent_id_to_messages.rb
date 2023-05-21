class AddColumnParentIdToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :parent_id, :integer
    add_foreign_key :messages, :messages, column: :parent_id, null: true
  end
end
