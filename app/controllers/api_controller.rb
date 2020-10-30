# frozen_string_literal: true

class ApiController < ApplicationController
  protected
    def current_user
      @user ||= User.find(request.headers["USER_ID"])
    end

    def authenticate_user!
      current_user.present?
    end
end
