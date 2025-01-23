class UpdateUsersTable < ActiveRecord::Migration[8.0]
  def change
    # Add default value and null constraint to role
    change_column :users, :role, :integer, default: 0, null: false

    # Add default value and null constraint to correct_submissions
    change_column :users, :correct_submissions, :integer, default: 0, null: false

    # Add default value and null constraint to total_submissions
    change_column :users, :total_submissions, :integer, default: 0, null: false

    # Add a unique index to the email column
    unless index_exists?(:users, :email)
      add_index :users, :email, unique: true
    end
  end
end
