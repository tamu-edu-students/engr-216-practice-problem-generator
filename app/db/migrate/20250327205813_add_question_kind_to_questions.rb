class AddQuestionKindToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :question_kind, :string
  end
end
