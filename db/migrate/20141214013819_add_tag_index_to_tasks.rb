class AddTagIndexToTasks < ActiveRecord::Migration
  def change
    add_index :tasks, :tags, using: 'gin'
  end
end
