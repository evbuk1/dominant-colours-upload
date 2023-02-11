# frozen_string_literal: true

class ApplicationController < ActionController::API

  private

  def make_index(cls, collection)
    puts request.query_parameters
    cls.new request.path, ActionController::Parameters.new(request.query_parameters), collection
  end
end
