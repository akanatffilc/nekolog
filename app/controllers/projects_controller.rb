class ProjectsController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => @space_id})
    render :json => {'projects' => backlog.get_projects}
  end
end
