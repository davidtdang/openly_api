class LocationsController < ApplicationController

  def index
    params[:ll]  #=> ?ll="'36.142064,-86.816086'"

    client = Foursquare2::Client.new(:client_id => ENV["FOURSQUARE_CLIENT_ID"], :client_secret => ENV["FOURSQUARE_CLIENT_SECRET"], :api_version => '20150329')
    # results = client.search_venues(ll: params[:ll], query: params[:s] )
    results = client.search_venues(:ll => '36.142064,-86.816086')

    venues = []
    venue_call_errors = 0
    results.venues.each do |venue|
      begin
        store_id = venue["storeId"]
        venues << client.venue(store_id) if store_id
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
    #   {
    #     name: venue.name,
    #     phone: venue.contact.formattedPhone,
    #     address: venue.location.address,
    #     city: venue.location.city,
    #     state: venue.location.state,
    #     lat: venue.location.lat,
    #     lng: venue.location.lng,
    #     postalCode: venue.location.postalCode,
    #     formattedAddress: venue.location.formattedAddress,
    #    }
    #  end

    # @venues = venues.map do |venue|
    #     {
    #       name: venue["response"]["name"],
    #     }
    # end
    render json:venues
  end



end
