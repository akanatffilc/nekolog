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
			'issueKey'  => mi.issueKey, 
			'summary' 	=> mi.summary, 
			'priority' 	=> { 
				'id' 	=> mi.priority.id,
				'name' 	=> mi.priority.name
			},
			'status' 	=> {
				'id'	=> mi.status.id,
				'name'	=> mi.status.name,
			}
		}
	end	

	chuu_issues.each do | chuu | 
		issues[:chuu] << {
			'issueKey'  => chuu.issueKey, 
			'summary' 	=> chuu.summary, 
			'priority' 	=> { 
				'id' 	=> chuu.priority.id,
				'name' 	=> chuu.priority.name
			},
			'status' 	=> {
				'id'	=> chuu.status.id,
				'name'	=> chuu.status.name,
			}
		}
	end

	zumi_issues.each do | zumi | 
		issues[:zumi] << {
			'issueKey'  => zumi.issueKey, 
			'summary' 	=> zumi.summary, 
			'priority' 	=> { 
				'id' 	=> zumi.priority.id,
				'name' 	=> zumi.priority.name
			},
			'status' 	=> {
				'id'	=> zumi.status.id,
				'name'	=> zumi.status.name,
			}
		}
	end

    @issues = issues 
  end
  def test
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
			'issueKey'  => mi.issueKey, 
			'summary' 	=> mi.summary, 
			'priority' 	=> { 
				'id' 	=> mi.priority.id,
				'name' 	=> mi.priority.name
			},
			'status' 	=> {
				'id'	=> mi.status.id,
				'name'	=> mi.status.name,
			}
		}
	end	

	chuu_issues.each do | chuu | 
		issues[:chuu] << {
			'issueKey'  => chuu.issueKey, 
			'summary' 	=> chuu.summary, 
			'priority' 	=> { 
				'id' 	=> chuu.priority.id,
				'name' 	=> chuu.priority.name
			},
			'status' 	=> {
				'id'	=> chuu.status.id,
				'name'	=> chuu.status.name,
			}
		}
	end

	zumi_issues.each do | zumi | 
		issues[:zumi] << {
			'issueKey'  => zumi.issueKey, 
			'summary' 	=> zumi.summary, 
			'priority' 	=> { 
				'id' 	=> zumi.priority.id,
				'name' 	=> zumi.priority.name
			},
			'status' 	=> {
				'id'	=> zumi.status.id,
				'name'	=> zumi.status.name,
			}
		}
	end

    @issues = issues 
    render :json => {'issues' => @issues}
  end
end
