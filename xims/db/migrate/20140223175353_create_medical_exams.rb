class CreateMedicalExams < ActiveRecord::Migration
  def change
    create_table :medical_exams do |t|
      t.integer :employee_id, null: false
      t.datetime :expiration_date, null: false
    end
  end
end
