class CreatePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permissions do |t|
      t.uuid :permission_id
      t.string :permission_name
      t.text :description

      t.timestamps
    end
  end
end
