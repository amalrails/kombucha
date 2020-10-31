# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::RatingsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "api/ratings").to route_to("api/ratings#index")
    end

    it "routes to #show" do
      expect(:get => "api/ratings/1").to route_to("api/ratings#show", :id => "1")
    end

    it "routes to #create" do
      expect(post: "api/ratings").to route_to("api/ratings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "api/ratings/1").to route_to("api/ratings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "api/ratings/1").to route_to("api/ratings#update", id: "1")
    end
  end
end
