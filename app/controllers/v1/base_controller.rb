# frozen_string_literal: true

module V1
  class BaseController < ApplicationController
    include ActionController::Cookies
    include UserAuthorizationHelper

    before_action :set_host_for_local_storage

    private

    def set_host_for_local_storage
      ActiveStorage::Current.host = request.base_url
    end
  end
end

