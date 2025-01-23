class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.integer :topic_id, null: false, unique: true
      t.string :topic_name, null: false

      t.timestamps
    end

    add_index :topics, :topic_id, unique: true
  end
end
