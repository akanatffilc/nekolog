class Issue < ActiveRecord::Base
  VIRTUAL_ATTRIBUTES = %i(issueKey summary description priority status assignee)
  attr_accessor(*VIRTUAL_ATTRIBUTES)

  attr_accessor :backlog_issue

  def self.create_or_update(params)
    issue = Issue.where("id = ?", params[:id]).first
    if issue
      issue.position = params[:position]
      issue.user_id = params[:user_id]
      issue.board_id = params[:board_id]
      issue.save()
    else
      issue = Issue.create(id: params[:id],
                           user_id: params[:user_id],
                           project_id: params[:project_id],
                           board_id: params[:board_id],
                           position: params[:position])
    end
    issue
  end

  def summary
    @backlog_issue.summary
  end

  def issueKey
    @backlog_issue.issueKey
  end

  def description
    @backlog_issue.description
  end

  def priority
    @backlog_issue.priority
  end

  def status
    @backlog_issue.status
  end

  def assignee
    @backlog_issue.assignee
  end

  def as_json(options = { })
    super((options || { }).merge({
      :methods => VIRTUAL_ATTRIBUTES
    }))
  end
end
