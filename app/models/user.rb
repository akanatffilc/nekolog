class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :issue_types

  def self.find_for_backlog(auth)
    user = User.where(email: auth.info.email).first

    if user
      user.access_token = auth.credentials.token
      user.refresh_token = auth.credentials.refresh_token
      user.save()
    else
      user = User.create(name:     auth.info.name,
                         provider: auth.provider,
                         uid:      auth.uid,
                         email:    auth.info.email,
                         access_token:  auth.credentials.token,
                         refresh_token: auth.credentials.refresh_token,
                         expired_at: auth.credentials.expires_in,
                         password: Devise.friendly_token[0, 20])
    end
    user
  end
end
