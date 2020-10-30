# frozen_string_literal: true

require 'rails_helper'

describe Api::KombuchasController, type: :request do
  let(:response_body) { JSON.parse(response.body) }
  let(:current_user) { create(:user) }
  let(:headers) { { 'USER_ID': current_user.id } }

  describe "#index" do
    it "renders a collection of kombuchas" do
      create_list(:kombucha, 5)

      get '/api/kombuchas', params: {}, headers: headers

      expect(response.status).to eq(200)
      expect(response_body.length).to eq(Kombucha.count)
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
