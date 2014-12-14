class AddExpirationToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :expiration, :date
  end
end
