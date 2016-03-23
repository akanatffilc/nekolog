class IssuesController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => 'globaldev'})
    render :json => {'issues' => backlog.get_issues(params)}
  end
end
