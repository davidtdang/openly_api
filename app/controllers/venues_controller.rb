class VenuesController < ApplicationController
  respond_to :json

  def splash

  end

  def show

    # response = Yelp.client.search('San Francisco', { term: params[:search], coordinates: "#{params[:lat]},#{params[:lng]}" })
    # businesses = response.businesses
    #
    # # @geojson = Array.new
    # # @businesses.each do |business|
    # #   @geojson << {
    # #       type: 'Feature',
    # #       geometry: {
    # #           type: 'Point',
    # #           coordinates: [business.location.coordinate.longitude, business.location.coordinate.latitude]
    # #       },
    # #       properties: {
    # #           name: business.name,
    # #           address: "#{business.location.display_address.first }, #{business.location.display_address.last}",
    # #           :'marker-color' => '#00607d',
    # #           :'marker-symbol' => 'circle',
    # #           :'marker-size' => 'medium'
    # #       }
    # #   }
    # #
    # #   respond_to do |format|
    # #     format.html
    # #     format.json { render json: @geojson }
    # #   end
    # #
    # # end
    #
    #
    #
    # @businesses = businesses.map do |business|
    #   {
    #     name: business.name,
    #     url: business.url,
    #     image_url: business.image_url,
    #     review_count: business.review_count,
    #     categories: business.categories,
    #     star_rating: business.rating_img_url,
    #     rating: business.rating,
    #     address: "#{business.location.display_address.first }, #{business.location.display_address.last}",
    #     phone: display_phone(business.display_phone)
    #     geocoords: [business.location.coordinate.longitude, business.location.coordinate.latitude],
    #   }
    # end
    # render restaurant_path
  end

  def search_yelp
    # response = Yelp.client.search('San Francisco', { term: params[:s], coordinates: "#{params[:lat]},#{params[:lng]}" })
    response = Yelp.client.search('San Francisco', {term: params[:s]})


    businesses = response.businesses.map do |business|

      categories = business.categories.map do |category_arr|
        category_arr.first
      end

      {
        name: business.name,
        url: business.url,
        # image_url: business.image_url,
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
