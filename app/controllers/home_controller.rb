class HomeController < ApplicationController
  def index
  	backlog = BacklogService.new(current_user, {:space_id => @space_id})
    params['statusId'] = ['1']
    mi_issues = backlog.get_issues_status(params)
    params['statusId'] = ['2']
    chuu_issues = backlog.get_issues_status(params)
    params['statusId'] = ['3']
    zumi_issues = backlog.get_issues_status(params)
    # p zumi_issues

	issues = Hash.new { |issues,k| issues[k] = [] }
	mi_issues.each do | mi | 
		issues[:mi] << {
			'issueKey'  	=> mi.issueKey, 
			'summary' 		=> mi.summary, 
			'description' 	=> mi.description, 
			'priority' 		=> { 
				'id' 		=> mi.priority.id,
				'name' 		=> mi.priority.name,
			},
			'status' 		=> {
				'id'		=> mi.status.id,
				'name'		=> mi.status.name,
			},
			'assignee'		=> {
				'id'		=> "",
				'name'		=> "",
			}
		}
	end	

	chuu_issues.each do | chuu | 
		issues[:chuu] << {
			'issueKey'  	=> chuu.issueKey, 
			'summary' 		=> chuu.summary, 
			'description' 	=> chuu.description, 
			'priority' 		=> { 
				'id' 		=> chuu.priority.id,
				'name' 		=> chuu.priority.name
			},
			'status' 		=> {
				'id'		=> chuu.status.id,
				'name'		=> chuu.status.name,
			},
			'assignee'		=> {
				'id'		=> "",
				'name'		=> "",
			}
		}
	end

	zumi_issues.each do | zumi | 
		issues[:zumi] << {
			'issueKey'  	=> zumi.issueKey, 
			'summary' 		=> zumi.summary, 
			'description' 	=> zumi.description, 
			'priority' 		=> { 
				'id' 		=> zumi.priority.id,
				'name' 		=> zumi.priority.name
			},
			'status' 		=> {
				'id'		=> zumi.status.id,
				'name'		=> zumi.status.name,
			},
			'assignee'		=> {
				'id'		=> "",
				'name'		=> "",
			}
		}
	end

    @issues = issues 
  end

  def test
  end
end
