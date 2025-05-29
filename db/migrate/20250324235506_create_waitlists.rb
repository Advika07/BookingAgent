class CreateWaitlists < ActiveRecord::Migration[7.1]
  def change
    create_table :waitlists do |t|
      t.uuid :waitlist_id
      t.uuid :store_id
      t.uuid :assignment_id
      t.uuid :client_id
      t.uuid :service_id
      t.integer :waitlist_position
      t.datetime :notified_at
      t.string :waitlist_status
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
