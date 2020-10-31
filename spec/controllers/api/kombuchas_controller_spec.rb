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

      context 'Params of fizziness is provided:' do
        let(:kombucha_count) { Kombucha.where(fizziness_level: 'high').count }

        it "renders a collection of kombuchas, which are filtered based on the fizziness param value" do
          get '/api/kombuchas', params: { 'fizziness': 'high' }, headers: headers

          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

      context 'Params of vegan is provided:' do
        let(:kombucha_count) { Kombucha.includes(:ingredients)
                                       .where(ingredients: { vegan: 'true' }).count }

        it "renders a collection of kombuchas, which are filtered based on the vegan param value" do
          get '/api/kombuchas', params: { 'vegan': 'true' }, headers: headers

          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

      context 'Params of vegan and caffeine_free is provided:' do
        let(:kombucha_count) { Kombucha.includes(:ingredients)
                                       .where(ingredients: { vegan: true,
                                                             caffeine_free: true }).count }

        it "renders a collection of kombuchas, which are filtered based on the vegan, fizziness and caffeine_free params value" do
          get '/api/kombuchas', params: { 'vegan': 'true', 'caffeine_free': 'true' }, headers: headers

          expect(response.status).to eq(200)
          expect(response_body.length).to eq(kombucha_count)
        end
      end

      context 'Params of vegan, fizziness and caffeine_free is provided:' do
        let(:kombucha_count) { Kombucha.where(fizziness_level: 'high')
                                       .includes(:ingredients)
                                       .where(ingredients: { vegan: true,
                                                             caffeine_free: true }).count }

        it "renders a collection of kombuchas, which are filtered based on the vegan, fizziness and caffeine_free params value" do
          get '/api/kombuchas', params: { 'fizziness': 'high', 'vegan': 'true', 'caffeine_free': 'true' }, headers: headers

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
