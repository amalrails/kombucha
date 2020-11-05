# frozen_string_literal: true

require 'rails_helper'

describe Api::KombuchasController, type: :request do
  let(:response_body) { JSON.parse(response.body) }
  let(:current_user) { create(:user) }
  let(:headers) { { 'USER_ID': current_user.id } }

  describe "#index" do
    context 'Unfiltered collection:' do
      before do
        create_list(:kombucha, 5)
      end

      it "renders a collection of kombuchas" do
        get '/api/kombuchas', params: {}, headers: headers

        expect(response.status).to eq(200)
        expect(response_body.length).to eq(Kombucha.count)
      end
    end

    context 'Filtered collection:' do
      before(:all) do
        %w(low medium high).map do |fizz|
          create_list(:kombucha, 3, fizziness_level: fizz, vegan: true, caffeine_free: true)
        end
      end

      context 'Filter by fizziness:' do
        let(:kombucha_count) { Kombucha.where(fizziness_level: 'high').count }

        it "renders a collection of kombuchas, which are filtered based on the given fizziness value" do
          get '/api/kombuchas', params: { 'fizziness': 'high' }, headers: headers

          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

      context 'Filter by vegan:' do
        let(:kombucha_count) { Kombucha.includes(:ingredients)
                                       .where(ingredients: { vegan: 'true' }).count }

        it "renders a collection of kombuchas, which are filtered based on the given vegan value" do
          get '/api/kombuchas', params: { 'vegan': 'true' }, headers: headers

          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

      context 'Filter by caffeine_free:' do
        let(:kombucha_count) { Kombucha.includes(:ingredients)
                                       .where(ingredients: { caffeine_free: 'true' }).count }

        it "renders a collection of kombuchas, which are filtered based on the given vegan value" do
          get '/api/kombuchas', params: { 'caffeine_free': 'true' }, headers: headers

          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

      context 'Filter by vegan and caffeine_free:' do
        let(:kombucha_count) { Kombucha.includes(:ingredients)
                                       .where(ingredients: { vegan: true,
                                                             caffeine_free: true }).count }

        it "renders a collection of kombuchas, which are filtered based on the given vegan,
              fizziness and caffeine_free value" do
          get '/api/kombuchas', params: { 'vegan': 'true', 'caffeine_free': 'true' }, headers: headers

          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

      context 'Filter by vegan, fizziness and caffeine_free:' do
        let(:kombucha_count) { Kombucha.where(fizziness_level: 'high')
                                       .includes(:ingredients)
                                       .where(ingredients: { vegan: true,
                                                             caffeine_free: true }).count }

        it "renders a collection of kombuchas, which are filtered based on the given vegan, fizziness and caffeine_free value" do
          get '/api/kombuchas', params: { 'fizziness': 'high', 'vegan': 'true', 'caffeine_free': 'true' }, headers: headers

          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

      context 'Filter by ingredient:' do
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
        let(:kombucha_count) { Kombucha.includes(:ingredients).where(ingredients: { name: ing_name }).count }
        let(:ing_name) { common_ingredient.name }

        it "renders a collection of kombuchas, which are filtered based on the given ingredient value" do
          get '/api/kombuchas', params: { ingredient: ing_name }, headers: headers
          expect(response_body.map {|kom| Kombucha.find(kom['id']).ingredients.pluck(:name).include?(common_ingredient.name)}.uniq).to eq([true])
          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

      context 'Filter by excluded ingredient:' do
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
        let(:exc_ing_name) { common_ingredient.name }
        let(:kombucha_count) { Kombucha.includes(:ingredients).references(:ingredients).where.not(ingredients: { name: exc_ing_name }).count }

        it "renders a collection of kombuchas, which are filtered by excluding the given ingredient value" do
          get '/api/kombuchas', params: { excluded_ingredient: exc_ing_name }, headers: headers

          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

    end
  end

  describe "#show" do
    it "shows a kombucha" do
      kombucha = create(:kombucha)

      get "/api/kombuchas/#{kombucha.id}", params: {}, headers: headers

      expect(response.message).to eq("OK")
      expect(response_body["id"]).to eq(kombucha.id)
    end
  end

  describe "#create" do
    let(:request_params) {
      {
        kombucha: {
          name: "Orange Pop",
          fizziness_level: "low"
        }
      }
    }

    it "creates a kombucha" do
      expect { post "/api/kombuchas", params: request_params, headers: headers }.to change(Kombucha, :count).by(1)
    end

    it "does not create kombucha if fizziness level is invalid" do
      request_params[:kombucha][:fizziness_level] = "fake"

      expect { post "/api/kombuchas", params: request_params, headers: headers }.not_to change(Kombucha, :count)
    end
  end

  describe "#update" do
    let(:request_params) {
      {
        kombucha: {
          name: "new name",
          fizziness_level: "low"
        }
      }
    }

    it "updates kombucha fizziness level and name" do
      kombucha = create(:kombucha)

      patch "/api/kombuchas/#{kombucha.id}", params: request_params, headers: headers

      expect(response.message).to eq("OK")
      expect(response_body["name"]).to eq("new name")
    end

    it "does not update kombucha if fizziness level is invalid" do
      kombucha = create(:kombucha)

      request_params[:kombucha][:fizziness_level] = "fake"

      patch "/api/kombuchas/#{kombucha.id}", params: request_params, headers: headers

      expect(response.message).to eq("Unprocessable Entity")
    end
  end
end
