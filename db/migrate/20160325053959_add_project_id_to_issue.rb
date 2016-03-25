class AddProjectIdToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :project_id, :string
    add_reference :issues, :user
  end
end
