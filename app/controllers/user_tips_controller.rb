class UserTipsController < ApplicationController

  def create
    venue = Venue.find_or_create_by(yelp_id:params[:venue_id])
    venue.user_tips.create(text:params[:user_tip])
    render nothing: true, status: 200
  end

end
