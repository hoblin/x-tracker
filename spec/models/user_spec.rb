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
require "rails_helper"

RSpec.describe User, type: :model do
end
