class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :sha1, limit: 40
      t.string :original_filename, null: false
      t.integer :filesize, null: false
      t.integer :width
      t.integer :height
      t.string :url, null: false
      t.integer :uploaded_by_id, null: false
      t.integer :uploadable_id
      t.string :uploadable_type
      t.timestamps
    end
  end
end
