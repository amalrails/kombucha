# frozen_string_literal: true

require 'rails_helper'

describe Api::RatingsController, type: :request do
  let(:response_body) { JSON.parse(response.body) }
  let(:current_user) { create(:user) }
  let(:headers) { { 'USER_ID': current_user.id } }
  let(:create_kombuchas) do
    %w(low medium high).map do |fizz|
      create_list(:kombucha, 5, fizziness_level: fizz, vegan: true, caffeine_free: true)
    end
  end

  let(:valid_attributes) {
    { score: 4.5, user_id: current_user.id, kombucha_id: create_kombuchas[0][0].id }
  }

  describe "#index" do
    it "renders a collection of ratings" do
      Rating.create! valid_attributes
      get '/api/ratings', params: {}, headers: headers

      expect(response.status).to eq(200)
      expect(response_body.length).to eq(Rating.count)
      expect(response_body.first['avg_rating']).to eq('4.5')
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      rating = Rating.create! valid_attributes
      get "/api/ratings/#{rating.id}", params: {}, headers: headers

      expect(response.message).to eq("OK")
      expect(response_body["id"]).to eq(rating.id)
      expect(response_body["avg_rating"]).to eq('4.5')
    end
  end

  describe "#create" do
    let(:valid_request_params) {
      {
        rating: {
          score: 3.5,
            user_id: current_user.id,
            kombucha_id: create_kombuchas[0][1].id
        }
      }
    }

    let(:invalid_request_params) {
      {
        rating: {
          score: 3.5,
            user_id: current_user.id,
            kombucha_id: ''
        }
      }
    }

    it "creates a rating" do
      expect { post "/api/ratings", params: valid_request_params, headers: headers }.to change(Rating, :count).by(1)
      expect(response_body["avg_rating"]).to eq('3.5')
    end

    it "does not create rating if attributes are invalid" do
      expect { post "/api/ratings", params: invalid_request_params, headers: headers }.not_to change(Rating, :count)
    end
  end

  describe "#update" do
    let(:kombucha1) { create(:kombucha) }
    let(:kombucha2) { create(:kombucha) }
    let(:valid_request_params) {
      {
        rating: {
          score: 2.5,
            user_id: current_user.id,
            kombucha_id: kombucha1.id
        }
      }
    }

    let(:invalid_request_params) {
      {
        rating: {
          score: -3.5,
            user_id: current_user.id,
            kombucha_id: kombucha2.id
        }
      }
    }

    it "updates rating" do
      rating = create(:rating, score: 3.5, user_id: current_user.id, kombucha_id: kombucha1.id)

      patch "/api/ratings/#{rating.id}", params: valid_request_params, headers: headers

      expect(response.message).to eq("OK")
      expect(response_body["score"].to_f).to eq(rating.reload.score.to_f)
      expect(response_body["avg_rating"].to_f).to eq(rating.reload.avg_rating.to_f)
    end

    it "does not update rating if score is invalid" do

      rating = create(:rating, score: 3.5, user_id: current_user.id, kombucha_id: kombucha2.id)

      patch "/api/ratings/#{rating.id}", params: invalid_request_params, headers: headers

      expect(response.message).to eq("Unprocessable Entity")
    end
  end
end
