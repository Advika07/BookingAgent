class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.uuid :user_id
      t.string :auth0_id
      t.string :name
      t.string :email
      t.string :phone_number
      t.boolean :is_verified
      t.boolean :multi_store_access
      t.string :image
      t.string :preferred_language
      t.datetime :last_login
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :users, :email
  end
end
