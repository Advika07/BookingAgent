class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.uuid :client_id
      t.uuid :store_id
      t.uuid :global_client_id
      t.string :client_segment
      t.boolean :blocked
      t.text :notes
      t.boolean :marketing_opt_in
      t.string :source_channel
      t.integer :loyalty_points

      t.timestamps
    end
  end
end
