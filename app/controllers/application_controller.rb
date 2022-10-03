# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :current_user

  include Pundit
  def make_index(cls, collection)
    cls.new request.path, ActionController::Parameters.new(request.query_parameters), collection
  end
end
