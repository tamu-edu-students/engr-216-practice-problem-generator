class AddInstructorIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :instructor_id, :integer
    add_foreign_key :users, :users, column: :instructor_id
  end
end

