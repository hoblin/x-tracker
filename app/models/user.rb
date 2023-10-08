# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  encrypted_password  :string           default(""), not null
#  remember_created_at :datetime
#  username            :string           default(""), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :rememberable, :validatable

  # TODO: Implement transfering tweets and tweet metrics to admin before deleting the user
  has_many :tweets
  has_many :tweet_metrics

  validates :username, presence: true, uniqueness: {case_sensitive: false}

  def admin?
    username == Rails.application.credentials.admin_user.username
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end
end
