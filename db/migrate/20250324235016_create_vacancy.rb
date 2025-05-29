class CreateVacancy < ActiveRecord::Migration[7.1]
  def change
    create_table :vacancies do |t|
      t.uuid :vacancy_id
      t.uuid :store_id
      t.string :skill_tags
      t.string :vacancy_name
      t.boolean :occupied

      t.timestamps
    end
  end
end
