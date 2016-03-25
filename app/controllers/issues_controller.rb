class IssuesController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => @space_id})
    backlog_issues = backlog.get_issues({'projectId' => [params[:projectId].to_i]})
    nekolog_issues = Issue.where('project_id = ?', params[:projectId])
    issue_ids_already_exists = nekolog_issues.map do |i|
      i.id.to_i
    end

    issues = []
    mergedIssue = Struct.new("MergedIssue", :id, :summary, :position)
    backlog_issues.each do |issue|
      unless issue_ids_already_exists.include? issue.id
        issue = mergedIssue.new(issue.id, issue.summary, 0.0)
        issues << issue
      end
    end
    render :json => {'issues' => issues}
  end

  def create
    issue = Issue.create(id: params[:id],
                         user_id: current_user.id,
                         project_id: params[:project_id],
                         position: params[:position])

    render :json => {'status' => 'ok', 'debug' => issue.inspect}
  end

  def update
    if params.include? :position
      params[:user_id] = current_user.id
      issue = Issue.create_or_update(params)
    end
    render :json => {'status' => 'ok', 'debug' => issue.inspect}
  end
end
