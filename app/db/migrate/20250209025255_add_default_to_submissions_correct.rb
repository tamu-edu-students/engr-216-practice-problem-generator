class AddDefaultToSubmissionsCorrect < ActiveRecord::Migration[8.0]
  def change
    change_column_default :submissions, :correct, false
    change_column_null :submissions, :correct, false
  end
end
