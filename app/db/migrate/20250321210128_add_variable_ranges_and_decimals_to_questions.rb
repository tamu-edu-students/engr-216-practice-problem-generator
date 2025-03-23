class AddVariableRangesAndDecimalsToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :variable_ranges, :json
    add_column :questions, :variable_decimals, :json
  end
end
