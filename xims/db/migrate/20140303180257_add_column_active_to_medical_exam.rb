class AddColumnActiveToMedicalExam < ActiveRecord::Migration
  def change
    add_column :medical_exams, :active, :boolean, null: true
  end
end
