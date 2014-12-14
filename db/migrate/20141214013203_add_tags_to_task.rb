class AddTagsToTask < ActiveRecord::Migration
  def change
     add_column :tasks, :tags, :string, array: true, default: []
  end
end
