class CreateIncidents < ActiveRecord::Migration
  def change
    create_table :incidents do |t|
      t.integer :incident_type_id, null: false
      t.datetime :occurrence_date, null: false
      t.timestamps
    end
  end
end
