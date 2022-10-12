# frozen_string_literal: true

module V1
  module Venues
    class VenuesController < BaseController

      def index
        venues_index = make_index(Indexes::Venue, Venue.all)
        render json: VenueSerializer.new(
          venues_index.filtered,
          venues_index.options
        )
      end

      def show
        venue = Venue.find(params[:id])
        render json: VenueSerializer.new(
          venue,
          include: Indexes::Venue::INCLUDES.dup
        )
      end

      def create
        new_venue = Venue.new
        location = Location.find(location_id) if location_id.present?
        attributes = params.require(:data)
                           .require(:attributes)
        new_venue.name = attributes[:name] if attributes.key?(:name)
        new_venue.location = location if location.present?

        new_venue.save!

        render json: VenueSerializer.new(
          new_venue
        ), status: :created
      end

      def update
        venue = Venue.find(params[:id])

        attributes = params.require(:data)
                           .require(:attributes)

        location = Location.find(location_id) if location_id.present?

        venue.name = attributes[:name] if attributes.key?(:name)
        venue.location = location if location.present?
        venue.save!

        render json: VenueSerializer.new(venue)
      end

      def destroy
        venue = Venue.find(params[:id])
        venue.destroy!
        head 204
      end

      private

      def location_id
        relations = params.require(:data).require(:relationships) if params[:data].key?(:relationships)
        relations[:location][:data][:id] if relations.present?
      end
    end
  end
end
