class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.boolean :correct, null:false,  default: false
      t.datetime :submitted_at, null:false, default: -> {"CURRENT_TIMESTAMP"}

      t.timestamps
    end
  end
end
