class TipsController < ApplicationController

  def create
    venue = Venue.find_or_create_by(yelp_id:params[:venue_id])
    venue.tips.create(text:params[:tip])
    render nothing: true, status: 200
  end

end
