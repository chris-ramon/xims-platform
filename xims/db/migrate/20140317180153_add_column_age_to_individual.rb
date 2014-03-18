class AddColumnAgeToIndividual < ActiveRecord::Migration
  def change
    add_column :individuals, :age, :integer
  end
end
