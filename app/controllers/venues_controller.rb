class VenuesController < ApplicationController

  def index
    # FOURSQUARE API///////////////
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

    @venues = venues.map do |venue|
      if venue.hours
        {
        # name: venue.name,
        monfrihours: venue.hours.timeframes[0]["open"],
        # address: venue.location.formattedAddress.join(" "),
        }
      else
        {}
      end

    # YELP API///////////////////////
    response = Yelp.client.search('San Francisco', {terms: params[:s]})

    businesses = responses.businesses.map do |businesss|

      categories = business.categories.map do |category_arr|
        category_arr.first
      end

      {
        name: business.name,
        phone:display_phone(business.display_phone),
        url: business.url,
        categories: categories,
        review_count: business.review_count,
        star_rating: business.rating,
        address: "#{business.location.display_address}, {business.location.display_address.last}",
        geocoords: [business.location.coordinate.longitude, business.location.coordinate.latitude],
      }
      render json: businesses
    end

  end

  private
  def display_phone(phone_number)
    piece = phone_number.split('-')
    "(#{piece[1]}) #{piece[2]}-#{piece[3]}"
  end
  


end
