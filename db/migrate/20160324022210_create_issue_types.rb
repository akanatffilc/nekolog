class CreateIssueTypes < ActiveRecord::Migration
  def change
    create_table :issue_types do |t|
      t.references :user
      t.string :project_id
      t.string :issue_type
      t.timestamps null: false
    end
  end
end
