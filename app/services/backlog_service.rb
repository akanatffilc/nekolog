class BacklogService
  def initialize(user, options)
    @client = BacklogKit::Client.new(
      space_id: options[:space_id],
      client_id: Rails.application.secrets.backlog_client_id,
      client_secret: Rails.application.secrets.backlog_client_secret,
      api_key: nil, # api_key should be nil
      access_token: user.access_token,
      refresh_token: user.refresh_token
    )
    begin
      myself = @client.get_myself
    rescue => e
      res = update_token
      user.access_token = res.body.access_token
      user.refresh_token = res.body.refresh_token
      user.save()
    end
  end

  def update_token
      # to avoid including Authorization paramenter in HTTP header when oauth2/token method called
      @client.api_key = 1
      res = @client.update_token
      @client.api_key = nil
      res
  end

  def get_projects
    projects = Rails.cache.fetch('projects', expires_in: 24.hour) do
      # singleton can't be dumped error occurs when trying to save BacklogKit::Resource instance
      raw_data = @client.get_projects.body
      data = raw_data.map do |d|
        d.dup
      end
    end
  end

  def get_issue_types(projectId)
    @client.get_issue_types(projectId).body
  end

  def get_issues(params)
    params.delete_if do |key, val|
      ['controller', 'action'].include? key
    end
    params['statusId'] = ['1', '2', '3']
    Rails.logger.debug params

    @client.get_issues(params).body
  end

  def get_issues_status(params)
    Rails.logger.debug params
    params.delete_if do |key, val|
      ['controller', 'action'].include? key
    end

    @client.get_issues(params).body
  end

  def get_issue(id)
    @client.get_issue(id).body
  end
end