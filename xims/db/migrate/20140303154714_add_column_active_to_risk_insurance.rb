class AddColumnActiveToRiskInsurance < ActiveRecord::Migration
  def change
    add_column :risk_insurances, :active, :boolean, null: true
  end
end
