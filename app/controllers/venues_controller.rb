
class VenuesController < ApplicationController
  respond_to :json


  def search_yelp(term)  #### gets YELP VENUES

    response ||= Rails.cache.fetch("find yelp venue " + term) do
      Yelp.client.search('San Francisco', {term: params[:s]}).businesses
    end

    return response
  end

  def search_google_places(term)   ##### gets GOOGLE VENUES which provides *place_id*

    results ||= Rails.cache.fetch("search_google_places" + term) do
      puts "saerching term " + term
      searchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{ENV["GOOGLE_PLACES_KEY"]}&location=37.767,-122.436&radius=5632&keyword=#{term}"
      reply_one = RestClient.get(searchURL)
      JSON.parse(reply_one)["results"]
    end
    return results


  end

  def find_google_place(place_id)  #### pass in *place id* to get specific GOOGLE venue details including *hours*
    results ||= Rails.cache.fetch("find google places" + place_id) do
      puts "finding google place id " + place_id
      searchURL = "https://maps.googleapis.com/maps/api/place/details/json?key=#{ENV["GOOGLE_PLACES_KEY"]}&placeid=#{place_id}"
      reply = RestClient.get(searchURL)
      JSON.parse(reply)["result"]
    end
    return results

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

    time = Time.new
    day_index = time.wday



    created = Time.now.strftime("%H%M").to_i

    matches = []
    yelp_venues.each do |business|
      matched_google_id = match_google_place_to_yelp_venue(business)
      if matched_google_id
        populated_place = find_google_place(matched_google_id)



        db_venue = Venue.find_by(yelp_id:business.id)
        begin
          user_tips = db_venue.user_tips
        rescue
          user_tips = nil
        end

        categories = business.categories.map do |category_arr|
          category_arr.first
        end

        matches << {
          persisted: !user_tips.nil?,
          user_tips: user_tips,
          id: business.id,
          name: business.name,
          geocoords: [business.location.coordinate.longitude, business.location.coordinate.latitude],
          address: "#{business.location.display_address.first }, #{business.location.display_address.last}",
          phone: display_phone(business),
          star_rating: business.rating_img_url,
          review_count: business.review_count,
          categories: categories,
          rating: business.rating,
          url: business.url,
          # hours: populated_place["opening_hours"],
          weekday_text: populated_place["opening_hours"]["weekday_text"],
          opening: (populated_place["opening_hours"]["periods"][day_index]["open"]["time"]),
          closing: (populated_place["opening_hours"]["periods"][day_index]["close"]["time"]),
          # hours_left:


        }
      end

    end
    # puts yelp_venues.length
    # puts matches.length
    # puts matches
    # puts created
    # puts matches
    render json: matches
  end




  private
  def display_phone(business)
    begin
      phone_number = business.display_phone
      parts = phone_number.split('-')
      "(#{parts[1]}) #{parts[2]}-#{parts[3]}"
    rescue
      "not available"
    end
  end

end
