class IssuesController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => @space_id})
    backlog_issues = backlog.get_issues({'projectId' => [params[:projectId].to_i]})

    mergedIssue = Struct.new("MergedIssue", :id, :summary, :position)
    issues = []

    if params[:boardId].present? then
      nekolog_issues = Issue.where('project_id = ? and board_id = ?', params[:projectId], params[:boardId])
      nekolog_issues.each do |ni|
        backlog_issue = nil
        backlog_issues.each do |bi|
          backlog_issue = bi if bi.id == ni.id
        end
        issue = mergedIssue.new(ni.id, backlog_issue.summary, ni.position)
        issues << issue
      end
    else
      nekolog_issues = Issue.where('project_id = ?', params[:projectId])

      issue_ids_already_exists = nekolog_issues.map do |i|
        i.id.to_i
      end

      backlog_issues.each do |issue|
        unless issue_ids_already_exists.include? issue.id
          issue = mergedIssue.new(issue.id, issue.summary, 0.0)
          issues << issue
        end
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
