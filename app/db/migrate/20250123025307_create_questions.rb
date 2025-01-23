class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :topic, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.string :img
      t.text :template_text, null: false
      t.text :equation
      t.json :variables, default: []
      t.text :answer
      t.integer :correct_submissions, default: 0
      t.integer :total_submissions, default: 0

      t.timestamps
    end
  end
end
