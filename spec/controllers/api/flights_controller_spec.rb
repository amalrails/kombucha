# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::FlightsController, type: :request do
  let(:response_body) { JSON.parse(response.body) }
  let(:current_user) { create(:user) }
  let(:headers) { { 'USER_ID': current_user.id } }
  before(:all) do
    create_list(:kombucha, 6, vegan: true, caffeine_free: true)
  end

  describe "#create" do
    context 'Optional attributes not given: ' do
      it "creates a flight of kombuchas" do
        expect { post "/api/flights", params: {}, headers: headers }.to change(Flight, :count).by(1)
        expect(response.status).to eq(200)
        expect(response_body["id"]).to eq(Flight.last.id)
      end

      it "creates a flight of kombuchas with uniq kombuchas" do
        post "/api/flights", params: {}, headers: headers
        expect(response_body["list"].uniq.size).to eq(Flight.last.list.uniq.size)
      end

      it "creates a flight of kombuchas with different tea base" do
        post "/api/flights", params: {}, headers: headers
        kombuchas = Kombucha.where(id: response_body["list"])
        expect(kombuchas.map { |kom| kom.ingredients.where(base: true).pluck(:name) }.flatten.uniq.size).to eq(4)
      end
    end

    context 'Optional attributes given: ' do
      context 'Recipe name is provided:' do
        let(:kom) { create(:kombucha, name: 'sample_kom', vegan: true, caffeine_free: true) }

        it "creates a flight of kombuchas, based on the given recipe name" do
          post '/api/flights', params: { 'recipe_name': kom.name }, headers: headers
          kombuchas = Kombucha.where(id: response_body["list"])
          expect(kombuchas.pluck(:name).include?(kom.name))
        end
      end

      context 'Avg rating is provided:' do
        let(:common_ingredient) { Ingredient.where(base: false).order(Arel.sql("RANDOM()")).last }
        let(:new_kombuchas) do
          5.times do
            kombucha = create(:kombucha, vegan: true, caffeine_free: true)
            user = create(:user)
            create(:rating, score: 3.5, user_id: user.id, kombucha_id: kombucha.id)
          end
        end
        let(:recipe_name) { common_ingredient.name }
        let(:rating) { 3 }

        it "creates a flight of kombuchas, based on the given avg rating" do
          new_kombuchas
          post '/api/flights', params: { 'avg_rating': rating }, headers: headers
          kombuchas = Kombucha.where(id: response_body["list"])
          kombuchas.each do |kom|
            expect(kom.ratings.pluck(:score).map { |score| score > rating }).to eq([true])
          end
        end
      end

      context 'Options of avg_rating and recipe_name is provided:' do
        let(:common_ingredient) { Ingredient.where(base: false).order(Arel.sql("RANDOM()")).last }

        let(:new_kombuchas) do
          5.times do
            kombucha = create(:kombucha, vegan: true, caffeine_free: true)
            user = create(:user)
            create(:rating, score: 3.5, user_id: user.id, kombucha_id: kombucha.id)
          end
        end
        let(:recipe_name) { common_ingredient.name }
        let(:kom) { create(:kombucha, name: 'sample_kom', vegan: true, caffeine_free: true) }
        let(:kom_rating) { create(:rating, score: 3.5, user_id: current_user.id, kombucha_id: kom.id) }

        let(:rating) { 3 }

        it "creates a flight of kombuchas, based on the given recipe name and rating" do
          new_kombuchas
          kom_rating
          post '/api/flights', params: { 'recipe_name': kom.name, 'avg_rating': rating }, headers: headers
          kombuchas = Kombucha.where(id: response_body["list"])

          expect(kombuchas.pluck(:name).include?(kom.name))
          kombuchas.each do |kom|
            expect(kom.ratings.pluck(:score).map { |score| score > rating }).to eq([true])
          end
        end
      end
    end
  end

  describe "#flight_picker" do
    context "Returns a flight: " do
      it "returns a random kombucha flight" do
        post "/api/flights", params: {}, headers: headers
        post "/api/flights", params: {}, headers: headers
        get "/api/flights/flight_picker", params: {}, headers: headers

        expect(response.message).to eq("OK")
        expect(Flight.pluck(:id).include?(response_body[:id]))
      end

      it "returns a random flight of kombuchas with uniq kombuchas" do
        post "/api/flights", params: {}, headers: headers
        post "/api/flights", params: {}, headers: headers
        get "/api/flights/flight_picker", params: {}, headers: headers

        expect(response_body["list"].uniq.size).to eq(4)
      end

      it "returns a random flight of kombuchas with different tea base" do
        post "/api/flights", params: {}, headers: headers
        post "/api/flights", params: {}, headers: headers
        get "/api/flights/flight_picker", params: {}, headers: headers

        kombuchas = Kombucha.where(id: response_body["list"])
        expect(kombuchas.map { |kom| kom.ingredients.where(base: true).pluck(:id) }.flatten.uniq.size).to eq(4)
      end
    end
  end
end
