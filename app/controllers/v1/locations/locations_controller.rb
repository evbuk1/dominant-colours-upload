# frozen_string_literal: true

module V1
  module Locations
    class LocationsController < BaseController

      def index
        locations_index = make_index(Indexes::Location, Location.all)
        render json: LocationSerializer.new(
          locations_index.filtered,
          locations_index.options
        )
      end

      def show
        location = Location.find(params[:id])
        render json: LocationSerializer.new(
          location,
          include: Indexes::Location::INCLUDES.dup
        )
      end

      def create
        new_location = Location.new(location_params)
        new_location.save!

        render json: LocationSerializer.new(
          new_location
        ), status: :created
      end

      def update
        location = Location.find(params[:id])

        attributes = params.require(:data)
                           .require(:attributes)

        return head 400 unless attributes.key?(:city) ||
                               attributes.key?(:state)

        location.update!(attributes.permit(:city, :state).to_h.compact)

        render json: LocationSerializer.new(location)
      end

      def destroy
        location = Location.find(params[:id])
        location.destroy!
        head 204
      end

      private

      def location_params
        params.require(:data).require(:attributes).permit(:city, :state)
      end
    end
  end
end
