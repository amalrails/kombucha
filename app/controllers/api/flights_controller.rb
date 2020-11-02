# frozen_string_literal: true

class Api::FlightsController < ApiController
  before_action :authenticate_user!
  before_action :fetch_flight, only: [:flight_picker]

  def flight_picker
    render json: @flight.as_json
  end

  def create
    @kombuchas = Kombucha.with_different_tea_base

    filtering_params(params).each do |key, value|
      if value.present?
        if key.eql?('recipe_name')
          kom_recipe = @kombuchas.filter_by_recipe_name(params[:recipe_name]).last
          @kombuchas = @kombuchas.where
                                 .not(id: [kom_recipe.id])
                                 .random_order
                                 .limit(3) << kom_recipe
        else
          @kombuchas = @kombuchas.where(id: Kombucha.public_send("filter_by_#{key}", value).pluck(:id))
        end
      end
    end
    @flight = Flight.new(list: @kombuchas.random_order.limit(4).pluck(:id))

    if @flight.save
      render json: @flight
    else
      render json: { errors:  @flight.errors }, status: :unprocessable_entity
    end
  end

  private

    def fetch_flight
      @flight = Flight.random_order.last
    end

    def filtering_params(params)
      params.slice(:avg_rating)
    end
end
