class UserTip < ActiveRecord::Base
  belongs_to :venue
  validates :text, presence: true
end
