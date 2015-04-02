class VenuesController < ApplicationController
  attr_reader: :venues

  def search # "/search"
    yelp_businesses = get_yelp_results
    foursquare_businesses = get_foursquare_results
    businesses = correlate_businesses(yelp_businesses, foursquare_businesses)

    render json:businesses
  end

  private
  def get_yelp_results
    res = Yelp.client.search('San Francisco', {terms: params[:s]})
    businesses = yelp_to_business(res)
    return businesses # array of yelp businesses
  end

  def get_foursquare_results
    client = FourSquare2::Client.new(:client => ENV["FOURSQUARE_CLIENT_ID"], :client_secret => ENV["FOURSQUARE_CLIENT_SECRET"], :api_version => '20150329')
    res = client.search_venues(:ll => '37.767, -122.436', query: params[:s])

    businesses = foursquare_to_business(res)
    return businesses
  end

  def yelp_to_business res
    #adapt res to standard business hashes
    formatted_businesses = []
    res.businesses.each do |business|

      categories = business.categories.map do |category_arr|
        category_arr.first
      end

      formatted_businesses.push({
        # attributes you care about
        y_name: business.name,
        y_url: business.url,
        y_review_count: business.review_count,
        y_categories: categories,
        y_rating: business.rating,
        y_address: "#{business.location.display_address.first }, #{business.location.display_address.last}",
        # y_phone: combine_phone(business.display_phone),
        y_geocoords: [business.location.coordinate.longitude, business.location.coordinate.latitude],
        y_lat: business.location.coordinate.latitude,
        y_lng: business.location.coordinate.longitude
        # ...
      })
    end
    return formatted_businesses
  end

  def foursquare_to_business res
    #adapt res to standard business hashes

    formatted_businesses = []
    res.venues.each do |business|
      fs_venue_details = client.venue(business["id"])
      fs_venue_hours = client.venue_hours(business["id"])
      formatted_businesses.push({
        # attributes you care about
        f_address: fs_venue_details.location.formattedAddress,
        f_lat: fs_venue_details.location.lat,
        f_lng: fs_venue_details.location.lng
        # puts f_hours: f_venue_hours
        # ...
      })
    end

    return formatted_businesses
  end

  def correlate_businesses(yelp_businesses, foursquare_businesses)
    correlated_businesses = []
    yelp_businesses.each do |y_biz|
      foursquare_businesses.each do |f_biz|
        if same_biz?(y_biz, f_biz)
          correlated_businesses.push({
            # biz as returned to front end
            name: y_biz.y_name,
            rating: y_biz.y_rating,
            address: y_biz.y_address,
            # phone: y_biz.y_phone,
            categories: y_biz.y_categories,
            # hours: f_biz.f_hours
          })
        end
      end
    end
  end

  # def combine_phone(phone_number)
  #   piece = phone_number.split('-')
  #
  #   "(#{piece[1]}) #{piece[2]}-#{piece[3]}"
  # end

  def same_biz?(y_biz, f_biz)
    difference_lats = y_biz.y_lat - f_biz.f_lat
    difference_lngs = y_biz.y_lng - f.biz.f_lng
    if difference lats > 0.0000001 || difference_lngs > 0.0000001
      same_biz = false
    elsif f_biz.f_address.gsbu(/\D/,"") != y_biz.y_address
      same_biz = false
    else
      same_biz = true
    # compare lat/lng
    # delta lat
    # delta lng

    # return #true/false
    end
  end
end
