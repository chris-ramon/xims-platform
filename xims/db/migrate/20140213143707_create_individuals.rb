class CreateIndividuals < ActiveRecord::Migration
  def change
    create_table :individuals do |t|
      t.integer :id_number, null: false
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name, null: false
      t.string :second_last_name, null: false
      t.timestamps
    end
  end
end
