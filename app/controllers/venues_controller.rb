
class VenuesController < ApplicationController
  respond_to :json

  def search
    # FOURSQUARE API/////////////////////////////////////////////////////
    # params[:ll]  #=> ?ll="'36.142064,-86.816086'"

    client = Foursquare2::Client.new(:client_id => ENV["FOURSQUARE_CLIENT_ID"], :client_secret => ENV["FOURSQUARE_CLIENT_SECRET"], :api_version => '20150329')
    # results = client.search_venues(ll: params[:ll], query: params[:s] )
    # results = client.search_venues(:ll => '40.721294,-73.983994')
    results = client.search_venues(:ll => '37.767, -122.436', query: params[:s])

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




    formatted_businesses = []
    results.venues.each do |business|

      venue_details = client.venue(business["id"])
      venue_hours = client.venue_hours(business["id"])



      formatted_businesses.push({
        name: venue_details.name,
        address: venue_details.location.formattedAddress[0..-2],
        phone: venue_details.contact.formattedPhone,
        lng: venue_details.location.lng,
        lat: venue_details.location.lat,
        geocoords: [venue_details.location.lng, venue_details.location.lat],
        # categories: categories,
        rating: venue_details.rating

        })


    end



    require 'pp'
    puts '@'*100

    pp formatted_businesses
    puts '@'*100

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
    # require 'pp'
    # puts '@'*100
    # hours_hash = client.venue_hours(results.venues[0]["id"])

    # info = client.venue(results.venues[0]["id"])
    # pp foursquare_lat = info.location.lat
    # pp foursquare_lng = info.location.lng

    # info = client.venue_hours(results.venues[0]["id"])
    #
    # foursquare_address = info.location.formattedAddress
    # foursquare_lat = info.location.lat
    # foursquare_lng = info.location.lng
    #
    # f_sq = [foursquare_lat, foursquare_lng, foursquare_address]

    # puts '@'*100




    render json: formatted_businesses
  end





  # YELP API/////////////////////////////////////////////////////
#
#   def search_yelp
#     response = Yelp.client.search('San Francisco', {term: params[:s]})
#     search_foursquare
#     businesses = response.businesses.map do |business|
#
#       categories = business.categories.map do |category_arr|
#         category_arr.first
#       end
#
#       {
#         name: business.name,
#         url: business.url,
#         review_count: business.review_count,
#         categories: categories,
#         star_rating: business.rating_img_url,
#         rating: business.rating,
#         address: "#{business.location.display_address.first }, #{business.location.display_address.last}",
#         phone: display_phone(business.display_phone),
#         geocoords: [business.location.coordinate.longitude, business.location.coordinate.latitude],
#         lat: business.location.coordinate.latitude,
#         lng: business.location.coordinate.longitude
#       }
#     end
#
#
#
#   render json: businesses
#
#   end
#
#
#   private
#     def display_phone(phone_number)
#       piece = phone_number.split('-')
#
#       "(#{piece[1]}) #{piece[2]}-#{piece[3]}"
#     end
# end
end
