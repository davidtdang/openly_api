class Venue < ActiveRecord::Base
  has_many :user_tips
  
end
