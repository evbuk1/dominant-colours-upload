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
        location = Location.find(location_id)
        new_venue.name = location_name
        new_venue.location = location

        new_venue.save!

        render json: VenueSerializer.new(
          new_venue
        ), status: :created
      end

      def update
        venue = Venue.find(params[:id])

        attributes = params.require(:data)
                           .require(:attributes)

        location = Location.find(location_id)

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
        params.require(:data).require(:relationships).require(:location).require(:data).require(:id)
      end

      def location_name
        params.require(:data).require(:attributes).require(:name)
      end
    end
  end
end
