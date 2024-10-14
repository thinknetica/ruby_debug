class AddHelpRequestsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hr_count, :integer, default: 0
  end
end
