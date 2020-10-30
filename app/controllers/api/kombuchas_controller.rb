# frozen_string_literal: true

class Api::KombuchasController < ApiController
  before_action :authenticate_user!
  before_action :set_kombucha, only: [:show, :update]

  def index
    @kombuchas = Kombucha.all
    render json: @kombuchas.map(&:to_h), status: :ok
  end

  def show
    render json: @kombucha.to_h
  end

  def create
    @kombucha = Kombucha.new(kombucha_params)

    if @kombucha.save
      render json: @kombucha.to_h
    else
      render json: { errors: @kombucha.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @kombucha.update(kombucha_params)
      render json: @kombucha.to_h
    else
      render json: { errors: @kombucha.errors }, status: :unprocessable_entity
    end
  end

  private
    def set_kombucha
      @kombucha = Kombucha.find(params[:id])
    end

    def kombucha_params
      params.require(:kombucha).permit(:name, :fizziness_level)
    end
end
