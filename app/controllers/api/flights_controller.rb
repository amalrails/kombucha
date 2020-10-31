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
      @kombuchas = @kombuchas.where(id: Kombucha.public_send("filter_by_#{key}", value).pluck(:id)) if value.present?
    end
    kombucha_ids = @kombuchas.random_order.limit(4).pluck(:id)
    @flight = Flight.new(list: kombucha_ids)

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
      params.slice(:avg_rating, :recipe_name)
    end
end
