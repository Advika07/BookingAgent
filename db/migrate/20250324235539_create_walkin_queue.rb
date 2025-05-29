class CreateWalkinQueue < ActiveRecord::Migration[7.1]
  def change
    create_table :walkin_queues do |t|
      t.uuid :queue_id
      t.uuid :store_id
      t.uuid :client_id
      t.uuid :service_id
      t.datetime :added_at
      t.string :status
      t.uuid :called_by

      t.timestamps
    end
  end
end
