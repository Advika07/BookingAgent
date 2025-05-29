class CreateApptInsight < ActiveRecord::Migration[7.1]
  def change
    create_table :appt_insights do |t|
      t.uuid :insight_id
      t.uuid :appt_id
      t.string :type
      t.json :value

      t.timestamps
    end
  end
end
