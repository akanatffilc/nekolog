class DashboardController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => @space_id})
    params['statusId'] = ['1']
    mi_issues = backlog.get_issues_status(params)
    params['statusId'] = ['2']
    chuu_issues = backlog.get_issues_status(params)
    # p chuu_issues
    params['statusId'] = ['3']
    zumi_issues = backlog.get_issues_status(params)
    # p zumi_issues

	issue = [] 
    # PHP
    # $arr = [];
    # foreach(backlog.get_issues(params) as $issue) {
    # 	if (!array_key_exists($issue.status), $arr) {
    # 		$arr[$issue.status.name] = new array();
    # 	}
    # 	$arr[$issue.status.name][] = $issue;
    # }

    # $arr => [
    # 	"未対応" => [
    # 		0 => IssueObject(),
    # 		1 => IssueObject(),
    # 	],
    # 	"対応中" => [
    # 		0 => IssueObject(),
    # 		1 => IssueObject(),
    # 	],
    # 	"処理済み" => [
    # 		0 => IssueObject(),
    # 		1 => IssueObject(),
    # 	],
    # ]
    
    issue.push(mi_issues)
    issue.push(chuu_issues)
    issue.push(zumi_issues)

    render :json => {'issues' => issue}
  end
end
