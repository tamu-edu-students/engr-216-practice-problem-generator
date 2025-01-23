class CreateTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :types do |t|
      t.integer :type_id, null: false, unique: true
      t.string :type_name, null: false

      t.timestamps
    end

    add_index :types, :type_id, unique: true
  end
end
