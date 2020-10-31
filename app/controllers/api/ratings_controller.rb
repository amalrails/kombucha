# frozen_string_literal: true

class Api::RatingsController < ApiController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]

  def index
    @ratings = Rating.all
    render json: @ratings.as_json, status: :ok
  end

  def show
    render json: @rating.as_json
  end

  def create
    @rating = Rating.new(rating_params)

    if @rating.save
      render json: @rating
    else
      render json: { errors:  @rating.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @rating.update(rating_params)
      render json: @rating.as_json
    else
      render json: { errors: @rating.errors }, status: :unprocessable_entity
    end
  end

  private

    def set_rating
      @rating = Rating.find(params[:id])
    end

    def rating_params
      params.require(:rating).permit(:score, :user_id, :kombucha_id)
    end
end
