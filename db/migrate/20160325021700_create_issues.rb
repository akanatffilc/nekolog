class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.float :position
      t.timestamps null: false
    end
  end
end
