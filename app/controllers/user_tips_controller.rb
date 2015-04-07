class UserTipsController < ApplicationController

  def create
    venue = Venue.find_or_create_by(yelp_id:params[:venue_id])
    venue.user_tips.create(text:params[:user_tip])
    render nothing: true, status: 200
  end

  def show
    venue = Venue.find_by yelp_id: params[:id]
    user_tips = venue.user_tips
    render json: user_tips
  end

end
