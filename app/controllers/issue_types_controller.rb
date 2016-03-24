class IssueTypesController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => @space_id})
    render :json => {'issue_types' => backlog.get_issue_types(params[:projectId])}
  end
end
