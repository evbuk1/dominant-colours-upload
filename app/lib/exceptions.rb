# frozen_string_literal: true

module Exceptions
  class UserNotAuthorizedToPerformThisAction < Pundit::NotAuthorizedError; end
end

