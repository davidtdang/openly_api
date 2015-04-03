
class VenuesController < ApplicationController
  respond_to :json
  require 'pp'
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


    renderme =""

    formatted_venues = []
    days_lib = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    results.venues.each do |venue|

      venue_details = client.venue(venue["id"])   ##### returns eveyrthing else JSON
      venue_hours = client.venue_hours(venue["id"])    ##### returns HOURS JSON
      hours = {}
      
      begin
        venue_hours["hours"]["timeframes"].each do |day_groups|
          day_groups["days"].each do |i|
            day_friendly = days_lib[i-1]
            hours[day_friendly] = day_groups["open"] ||= []
          end
        end
      rescue
        hours = {
          "Mon"=>[],
          "Tue"=>[],
          "Wed"=>[],
          "Thu"=>[],
          "Fri"=>[],
          "Sat"=>[],
          "Sun"=>[]
        }

      end
      pp venue_hours
      render nothing:true, status: 200
      return

      formatted_venues.push({
        name: venue_details.name,
        address: venue_details.location.formattedAddress[0..-2],
        phone: venue_details.contact.formattedPhone,
        lng: venue_details.location.lng,
        lat: venue_details.location.lat,
        geocoords: [venue_details.location.lng, venue_details.location.lat],
        # categories: categories,
        rating: venue_details.rating,
        hours: hours,
        venue_hours: venue_hours

        })


    end


    puts '@'*100

    pp formatted_venues
    puts '@'*100

    render json: formatted_venues


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
