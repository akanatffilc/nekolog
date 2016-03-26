class DashboardController < ApplicationController
  def index
    backlog = BacklogService.new(current_user, {:space_id => @space_id})
    params['statusId'] = ['1']
    mi_issues = backlog.get_issues(params)
    params['statusId'] = ['2']
    chuu_issues = backlog.get_issues(params)
    params['statusId'] = ['3']
    zumi_issues = backlog.get_issues(params)
    # p zumi_issues

	issues = Hash.new { |issues,k| issues[k] = [] }
	mi_issues.each do | mi | 
		issues[:mi] << mi.summary
	end	

	chuu_issues.each do | chuu | 
		issues[:chuu] << chuu.summary
	end

	zumi_issues.each do | zumi | 
		issues[:zumi] << zumi.summary
	end

    # issues[1].push(chuu_issues)
    # issues[2].push(zumi_issues)
    # PHP
    # $arr = [];
    # foreach(backlog.get_issues(params) as $issue) {
    # 	if (!array_key_exists($issue.status), $arr) {
    # 		$arr[$issue.status.name] = new array();
    # 	}
    # 	$arr[$issue.status.name][] = $issue;
    # }

    # $arr => [
    # 	"1" => [
    # 		0 => IssueObject(),
    # 		1 => IssueObject(),
    # 	],
    # 	"2" => [
    # 		0 => IssueObject(),
    # 		1 => IssueObject(),
    # 	],
    # 	"3" => [
    # 		0 => IssueObject(),
    # 		1 => IssueObject(),
    # 	],
    # ]
    @issues = issues 
    render 'dashboard/index'
  end


end
