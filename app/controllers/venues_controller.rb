
class VenuesController < ApplicationController
  respond_to :json

  def search_foursquare
    # FOURSQUARE API/////////////////////////////////////////////////////
    params[:ll]  #=> ?ll="'36.142064,-86.816086'"

    client = Foursquare2::Client.new(:client_id => ENV["FOURSQUARE_CLIENT_ID"], :client_secret => ENV["FOURSQUARE_CLIENT_SECRET"], :api_version => '20150329')
    # results = client.search_venues(ll: params[:ll], query: params[:s] )
    results = client.search_venues(:ll => '40.721294,-73.983994')

    venues = []
    venue_call_errors = 0
    results.venues.each do |venue|
      begin
        venues << client.venue(venue["id"])
      rescue
        venue_call_errors +=1
        puts "ERROR: Venue #{venue.name} with storeId #{venue["storeId"]} was not found. 4Square API"
      end
    end
    puts "Error report: venue_call_errors, #{venue_call_errors}"



    # venue = client.venue(75791)
    # #X puts hours_client
    # hours = venue.hours
    #X render :json => hours_client

    # @venues = venues.map do |venue|
    #   if venue.hours
    #     {
    #       # name: venue.name,
    #       monfrihours: venue.hours.timeframes[0]["open"],
    #       # address: venue.location.formattedAddress.join(" "),
    #     }
    #   else
    #     {}
    #   end
    # end
    require 'pp'
    puts '@'*100
    pp client.venue_hours(results.venues[0]["id"])
    puts '@'*100

    # render json: @venues
  end

  # YELP API/////////////////////////////////////////////////////

  def search_yelp
    response = Yelp.client.search('San Francisco', {term: params[:s]})
    search_foursquare
    businesses = response.businesses.map do |business|

      categories = business.categories.map do |category_arr|
        category_arr.first
      end

      {
        name: business.name,
        url: business.url,
        review_count: business.review_count,
        categories: categories,
        star_rating: business.rating_img_url,
        rating: business.rating,
        address: "#{business.location.display_address.first }, #{business.location.display_address.last}",
        phone: display_phone(business.display_phone),
        geocoords: [business.location.coordinate.longitude, business.location.coordinate.latitude],
      }
    end


    render json: businesses
  end


  private
    def display_phone(phone_number)
      piece = phone_number.split('-')

      "(#{piece[1]}) #{piece[2]}-#{piece[3]}"
    end
end
