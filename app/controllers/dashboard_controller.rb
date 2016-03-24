class DashboardController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => @space_id})
    render :json => {'issues' => backlog.get_issues(params)}
  end
end
