class AddRoundDecimalsToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :round_decimals, :integer
  end
end
