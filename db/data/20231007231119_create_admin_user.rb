# frozen_string_literal: true

class CreateAdminUser < ActiveRecord::Migration[7.1]
  def up
    return if User.exists?(username: Rails.application.credentials.admin_user.username)

    User.create! do |u|
      u.username = Rails.application.credentials.admin_user.username
      u.password = Rails.application.credentials.admin_user.password
      u.password_confirmation = Rails.application.credentials.admin_user.password
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
