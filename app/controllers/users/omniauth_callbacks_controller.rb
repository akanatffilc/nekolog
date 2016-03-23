class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def backlog
    @user = User.find_for_backlog(request.env["omniauth.auth"])
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Backlog"
      sign_in_and_redirect @user, :event => :authentication
    else
      # except extra prevent cookie overflow
      session["devise.backlog_data"] = request.env["omniauth.auth"].except("extra")
      if !@user.valid? && @user.errors[:email] then
        redirect_to new_user_session_url, alert: @user.errors[:email].first
      else
        redirect_to new_user_session_url
      end
    end
  end
end