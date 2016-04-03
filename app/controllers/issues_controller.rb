class IssuesController < ApplicationController
  def index
    params[:projectId] = [params[:projectId].to_i]
    params[:statusId] = params[:statusId].map {|i| i.to_i} if params[:statusId].present?

    backlog = BacklogService.new(current_user, {:space_id => @space_id})

    issues = []

    board_type = params[:type]
    params.delete :type
    backlog_issues = backlog.get_issues(params)
    nekolog_issues = Issue.where('project_id = ?', params[:projectId])
    issue_ids_already_exists = nekolog_issues.map do |i|
      i.id.to_i
    end

    if board_type == 'issues' then
      backlog_issues.each do |bi|
        unless issue_ids_already_exists.include? bi.id
          issue = Issue.new(id: bi.id, project_id: bi.projectId)
          issue.backlog_issue = bi
          issues << issue
        end
      end
    else
      backlog_issues.each do |bi|
        if issue_ids_already_exists.include? bi.id
          nekolog_issues.each do |ni|
            if ni.id == bi.id
              ni.backlog_issue = bi
              issues << ni
            end
          end
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
