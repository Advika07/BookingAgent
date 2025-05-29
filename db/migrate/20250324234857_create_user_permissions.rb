class CreateUserPermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_permissions do |t|
      t.uuid :user_permission_id
      t.uuid :assignment_id
      t.uuid :permission_id
      t.boolean :permission_toggle
      t.uuid :granted_by

      t.timestamps
    end
  end
end
