class AddBoardToIssue < ActiveRecord::Migration
  def change
    add_reference :issues, :board
  end
end
