class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :role, default: 0, null: false
      t.string :email, null: false
      t.integer :correct_submissions, default: 0, null: false
      t.integer :total_submissions, default: 0, null: false

      t.timestamps
    end

    # Add a unique index to the email column
    add_index :users, :email, unique: true
  end
end
