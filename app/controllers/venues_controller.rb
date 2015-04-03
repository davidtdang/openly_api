class VenuesController < ApplicationController
  respond_to :json


  def search_yelp

    response = Yelp.client.search('San Francisco', {term: params[:s]})


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
    parts = phone_number.split('-')

    "(#{parts[1]}) #{parts[2]}-#{parts[3]}"
  end
end
