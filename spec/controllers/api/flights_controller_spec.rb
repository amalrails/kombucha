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
    context 'Filter params not given: ' do
      it "creates a flight of kombuchas, which is not dependend on avg rating or any ingredient" do
        expect { post "/api/flights", params: {}, headers: headers }.to change(Flight, :count).by(1)
        expect(response_body["id"]).to eq(Flight.last.id)
        expect(response_body["list"].size).to eq(Flight.last.list.size)
        expect(response_body["list"].uniq).to eq(Flight.last.list)
      end
    end

    context 'Filter params are given: ' do
      context 'Only params of recipe_name is provided:' do
        let(:common_ingredient) { Ingredient.where(base: false).order(Arel.sql("RANDOM()")).last }

        let(:new_kombuchas) do
          base_ingredients = Ingredient.where(base: true).order(Arel.sql("RANDOM()")).limit(5)
          kombuchans = []
          base_ingredients.each do |base|
            ids = [base.id, common_ingredient.id]
            ids << Ingredient.where.not(id: common_ingredient.id).where(base: false)
                             .order(Arel.sql("RANDOM()")).limit(3).pluck(:id)
            ingredients = Ingredient.where(id: ids.flatten)
            kombucha = create(:kombucha, vegan: true, caffeine_free: true)
            kombuchans << kombucha
            kombucha.ingredients = ingredients
            kombucha.save!
          end
        end
        let(:recipe_name) { common_ingredient.name }
        let(:kombucha_count) { Kombucha.where(fizziness_level: 'high').count }

        it "creates a flight of kombuchas, based on given the recipe_name_param value" do
          new_kombuchas
          post '/api/flights', params: { 'recipe_name': recipe_name }, headers: headers
          expect { post "/api/flights", params: {}, headers: headers }.to change(Flight, :count).by(1)
          expect(response.status).to eq(200)
          expect(response_body["id"]).to eq(Flight.last.id)
          expect(response_body["list"].size).to eq(Flight.last.list.size)
          @kombuchas = Kombucha.where(id: response_body["list"])
          @kombuchas.each do |kom|
            expect(kom.ingredients.pluck(:name).include?(recipe_name))
          end
        end
      end

      context 'Only params of avg_rating is provided:' do
        let(:common_ingredient) { Ingredient.where(base: false).order(Arel.sql("RANDOM()")).last }

        let(:new_kombuchas) do
          base_ingredients = Ingredient.where(base: true).order(Arel.sql("RANDOM()")).limit(5)
          kombuchans = []
          base_ingredients.each do |base|
            ids = [base.id, common_ingredient.id]
            ids << Ingredient.where.not(id: common_ingredient.id).where(base: false)
                             .order(Arel.sql("RANDOM()")).limit(3).pluck(:id)
            ingredients = Ingredient.where(id: ids.flatten)
            kombucha = create(:kombucha, vegan: true, caffeine_free: true)
            create(:rating, score: 3.5, user_id: current_user.id, kombucha_id: kombucha.id)
            kombuchans << kombucha
            kombucha.ingredients = ingredients
            kombucha.save!
          end
        end
        let(:recipe_name) { common_ingredient.name }
        let(:kombucha_count) { Kombucha.where(fizziness_level: 'high').count }
        let(:rating) { 3 }

        it "creates a flight of kombuchas, based on given the recipe_name_param value" do
          new_kombuchas
          post '/api/flights', params: { 'avg_rating': rating }, headers: headers
          expect(response.status).to eq(200)
          expect(response_body["id"]).to eq(Flight.last.id)
          expect(response_body["list"].size).to eq(Flight.last.list.size)
          @kombuchas = Kombucha.where(id: response_body["list"])
          @kombuchas.each do |kom|
            expect(kom.ratings.pluck(:score).map { |score| score > rating }).to eq([true])
          end
        end
      end

      context 'Both params of avg_rating and recipe_name is provided:' do
        let(:common_ingredient) { Ingredient.where(base: false).order(Arel.sql("RANDOM()")).last }

        let(:new_kombuchas) do
          base_ingredients = Ingredient.where(base: true).order(Arel.sql("RANDOM()")).limit(5)
          kombuchans = []
          base_ingredients.each do |base|
            ids = [base.id, common_ingredient.id]
            ids << Ingredient.where.not(id: common_ingredient.id).where(base: false)
                             .order(Arel.sql("RANDOM()")).limit(3).pluck(:id)
            ingredients = Ingredient.where(id: ids.flatten)
            kombucha = create(:kombucha, vegan: true, caffeine_free: true)
            create(:rating, score: 3.5, user_id: current_user.id, kombucha_id: kombucha.id)
            kombuchans << kombucha
            kombucha.ingredients = ingredients
            kombucha.save!
          end
        end
        let(:recipe_name) { common_ingredient.name }
        let(:kombucha_count) { Kombucha.where(fizziness_level: 'high').count }
        let(:rating) { 3 }

        it "creates a flight of kombuchas, based on given the recipe_name_param value" do
          new_kombuchas
          post '/api/flights', params: { 'recipe_name': recipe_name, 'avg_rating': rating }, headers: headers
          expect(response.status).to eq(200)
          expect(response_body["id"]).to eq(Flight.last.id)
          expect(response_body["list"].size).to eq(Flight.last.list.size)
          @kombuchas = Kombucha.where(id: response_body["list"])
          @kombuchas.each do |kom|
            expect(kom.ingredients.pluck(:name).include?(recipe_name))
          end
          @kombuchas.each do |kom|
            expect(kom.ratings.pluck(:score).map { |score| score > rating }).to eq([true])
          end
        end
      end
    end
  end

  describe "#flight_picker" do
    it "returns a random kombucha flight" do
      post "/api/flights", params: {}, headers: headers
      get "/api/flights/flight_picker", params: {}, headers: headers

      expect(response.message).to eq("OK")
      expect(response_body["id"]).to eq(Flight.last.id)
      expect(response_body["list"].size).to eq(Flight.last.list.size)
    end
  end
end
