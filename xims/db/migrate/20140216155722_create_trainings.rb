class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.integer :organization_id, null: false
      t.integer :responsible_id
      t.integer :trainer_id, null: false
      t.integer :training_type, null: false
      t.datetime :training_date, null: false
      t.integer :training_hours, null: false
      t.string :topic, null: false
      t.timestamps
    end
  end
end
