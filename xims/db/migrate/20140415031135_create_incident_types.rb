class CreateIncidentTypes < ActiveRecord::Migration
  def change
    create_table :incident_types do |t|
      t.string :name, null: false
    end
  end
end
