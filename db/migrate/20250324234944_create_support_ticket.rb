class CreateSupportTicket < ActiveRecord::Migration[7.1]
  def change
    create_table :support_tickets do |t|
      t.uuid :ticket_id
      t.uuid :client_id
      t.string :subject
      t.text :description
      t.string :status
      t.uuid :assigned_to

      t.timestamps
    end
  end
end
