class CreateRiskInsurances < ActiveRecord::Migration
  def change
    create_table :risk_insurances do |t|
      t.integer :employee_id, null: false
      t.datetime :expiration_date, null: false
    end
  end
end
