class IssueTypesController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => @space_id})
    issue_types = backlog.get_issue_types(params[:projectId])
    checked_issue_types = IssueType.where(['user_id = ? and project_id = ?', current_user.id, params[:projectId]])

    render :json => {'issue_types' => issue_types, 'checked_types' => checked_issue_types.map {|t| t.issue_type.to_i}}
  end

  def update
    logger.debug params[:projectId]
    logger.debug params[:issueTypeId]

    IssueType.delete_all(['user_id = ? and project_id = ?', current_user.id, params[:projectId]])
    params[:issueTypeId].each do |type|
      IssueType.create(user_id: current_user.id, project_id: params[:projectId], issue_type: type)
    end

    render :json => {'status' => 'ok'}
  end
end
