class VenuesController < ApplicationController
  respond_to :json


  def search_yelp

    response = Yelp.client.search('San Francisco', {term: params[:s]})


    businesses = response.businesses.map do |business|

      categories = business.categories.map do |category_arr|
        category_arr.first
      end

      hours_arr = ["8:30","8:45","9:00","9:15","9:30","10:00","10:15"]








































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
        hours: hours_arr.sample
      }
    end

    render json: businesses
  end

  private

  def display_phone(phone_number)
    parts = phone_number.split('-')

    "(#{parts[1]}) #{parts[2]}-#{parts[3]}"
  end
end
