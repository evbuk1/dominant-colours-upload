# frozen_string_literal: true

module UserAuthorizationHelper
  extend ActiveSupport::Concern

  included do
    def check_user_exists!
      raise Exceptions::UnauthorizedError if current_user.nil?
    end
  end
end
