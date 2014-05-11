class CreateOutsourcings < ActiveRecord::Migration
  def change
    create_table :outsourcings do |t|
      t.integer :outsourcer_id, null: false
      t.integer :provider_id, null: false
      t.timestamps
    end
  end
end
