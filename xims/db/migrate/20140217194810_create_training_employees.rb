class CreateTrainingEmployees < ActiveRecord::Migration
  def change
    create_table :training_employees do |t|
      t.integer :training_id, null: false
      t.integer :employee_id, null: false
      t.text :observations
      t.timestamps
    end
  end
end
