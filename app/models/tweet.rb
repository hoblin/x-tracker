# == Schema Information
#
# Table name: tweets
#
#  id         :bigint           not null, primary key
#  author     :string
#  body       :text
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tweet < ApplicationRecord
  validates :url, presence: true, uniqueness: true

  before_validation :set_author

  private

  def set_author
    self.author = url&.split("/")&.fetch(3)
  end
end
