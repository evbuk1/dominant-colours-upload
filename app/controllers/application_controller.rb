# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!
  attr_reader :current_user

  include Pundit::Authorization

  def doorkeeper_unauthorized_render_options(*)
    { json: { errors: [{ title: 'Not authorised - please log in' }] } }
  end

  private

  def current_user
    Rails.logger.info "Doorkeeper token is #{doorkeeper_token}"
    @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
  def make_index(cls, collection)
    cls.new request.path, ActionController::Parameters.new(request.query_parameters), collection
  end
end
