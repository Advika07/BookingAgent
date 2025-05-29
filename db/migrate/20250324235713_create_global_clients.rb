class CreateGlobalClients < ActiveRecord::Migration[7.1]
  def change
    create_table :global_clients do |t|
      t.uuid :global_client_id
      t.string :client_name
      t.string :preferred_name
      t.string :preferred_contact_method
      t.string :client_email
      t.string :client_ph
      t.string :gender
      t.datetime :client_dob

      t.timestamps
    end
  end
end
