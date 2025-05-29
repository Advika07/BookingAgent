class CreateModelPredictions < ActiveRecord::Migration[7.1]
  def change
    create_table :model_predictions do |t|
      t.uuid :prediction_id
      t.string :prediction_model_name
      t.string :model_version
      t.string :target_entity_type
      t.uuid :target_table_id
      t.string :prediction_type
      t.decimal :prediction_value
      t.datetime :run_date

      t.timestamps
    end
  end
end
