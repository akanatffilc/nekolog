class IssueTypesController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => 'globaldev'})
    render :json => {'issue_types' => backlog.get_issue_types(params[:projectId])}
  end
end
