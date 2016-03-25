class Issue < ActiveRecord::Base

  def self.create_or_update(params)
    issue = Issue.where("id = ?", params[:id]).first
    if issue
      issue.position = params[:position]
      issue.save()
    else
      issue = Issue.create(id: params[:id],
                           user_id: params[:user_id],
                           project_id: params[:project_id],
                           position: params[:position])
    end
    issue
  end
end
