class ChangeColumnSecondLastNameToIndividual < ActiveRecord::Migration
  def change
    change_column :individuals, :second_last_name, :string, :null => true
  end
end
