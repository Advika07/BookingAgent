class CreateUserStoreAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :user_store_assignments do |t|
      t.uuid :assignment_id
      t.uuid :user_id
      t.uuid :store_id
      t.boolean :active
      t.string :role_name
      t.string :employment_type
      t.json :permissions

      t.timestamps
    end
  end
end
