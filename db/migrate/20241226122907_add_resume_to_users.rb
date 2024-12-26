class AddResumeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :resume, :string
  end
end
