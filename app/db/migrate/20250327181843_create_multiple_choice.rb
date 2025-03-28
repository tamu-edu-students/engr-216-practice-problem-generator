class CreateMultipleChoice < ActiveRecord::Migration[8.0]
  def change
    create_table :answer_choices do |t|
      t.references :question, null: false, foreign_key: true
      t.text :choice_text, null: false
      t.boolean :correct, null: false, default: false

      t.timestamps
    end
  end
end
