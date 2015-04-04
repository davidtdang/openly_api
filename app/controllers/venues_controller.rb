class VenuesController < ApplicationController
  respond_to :json

  def search_yelp(term)  #### gets YELP VENUES
    response = []
    response.concat(Yelp.client.search('San Francisco', {term: params[:s]}).businesses)

    return response
  end

  def search_google_places(term)   ##### gets GOOGLE VENUES which provides *place_id*
    searchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{ENV["GOOGLE_PLACES_KEY"]}&location=37.767,-122.436&radius=5632&keyword=#{term}"
    puts searchURL
    reply_one = RestClient.get(searchURL)
    page_one = JSON.parse(reply_one)

    # reply_two = RestClient.get(searchURL+"&pagetoken=#{page_one["next_page_token"]}")
    # page_two = JSON.parse(reply_two)
    #
    # reply_three = RestClient.get(searchURL+"&pagetoken=#{page_two["next_page_token"]}")
    # page_three = JSON.parse(reply_three)

    # reply_four = RestClient.get(searchURL+"&pagetoken=#{page_three["next_page_token"]}")
    # page_four = JSON.parse(reply_four)
    #
    # reply_five = RestClient.get(searchURL+"&pagetoken=#{page_four["next_page_token"]}")
    # page_five = JSON.parse(reply_five)

    results =[]
    results.concat(page_one["results"])
    # results.concat(page_two["results"])
    # results.concat(page_three["results"])
    # results.concat(page_four["results"])
    # results.concat(page_five["results"])


    # puts "@"*100

    # puts "@"*100
  end

  def find_google_place(place_id)  #### pass in *place id* to get specific GOOGLE venue details including *hours*
    searchURL = "https://maps.googleapis.com/maps/api/place/details/json?key=#{ENV["GOOGLE_PLACES_KEY"]}&placeid=#{place_id}"

    reply = RestClient.get(searchURL)
    JSON.parse(reply)["result"]

    # puts "@"*100
    # puts searchURL
    # puts "@"*100
  end


  def match_google_place_to_yelp_venue(business) ##### passes in all google place venues and ONE yelp venue


    results = search_google_places(business.phone)

    if results.length > 0
      return results[0]["place_id"]
    else
      false
    end
  end


  def find_venues
    yelp_venues = search_yelp(params[:s])

    matches = []
    yelp_venues.each do |business|
      matched_google_id = match_google_place_to_yelp_venue(business)
      if matched_google_id
        populated_place = find_google_place(matched_google_id)

        # venue_database = Venue.find_by(yelp_id:business.id)

        categories = business.categories.map do |category_arr|
          category_arr.first
        end

        matches << {
          name: business.name,
          geocoords: [business.location.coordinate.longitude, business.location.coordinate.latitude],
          address: "#{business.location.display_address.first }, #{business.location.display_address.last}",
          phone: display_phone(business.display_phone),
          star_rating: business.rating_img_url,
          review_count: business.review_count,
          categories: categories,
          rating: business.rating,
          url: business.url,
          hours: populated_place["opening_hours"]
        }
      end




    end
    puts yelp_venues.length
    puts matches.length
    render json: matches
  end




  private
  def display_phone(phone_number)
    parts = phone_number.split('-')

    "(#{parts[1]}) #{parts[2]}-#{parts[3]}"
  end

end
