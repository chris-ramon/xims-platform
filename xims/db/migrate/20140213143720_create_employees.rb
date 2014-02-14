class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :organization_id, null: false
      t.integer :individual_id, null: false
      t.integer :workspace_id, null: false
      t.integer :occupation_id, null: false
      t.timestamps
    end
  end
end
