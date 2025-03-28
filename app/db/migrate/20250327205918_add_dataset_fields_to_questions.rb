class AddDatasetFieldsToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :dataset_generator, :string
    add_column :questions, :answer_strategy, :string
  end
end
