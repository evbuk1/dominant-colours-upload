# frozen_string_literal: true

module V1
  module Events
    class EventsController < BaseController

      def index
        events_index = make_index(Indexes::Event, Event.all)
        render json: EventSerializer.new(
          events_index.filtered,
          events_index.options
        )
      end

      def show
        event = Event.find(params[:id])
        render json: EventSerializer.new(
          event,
          include: Indexes::Event::INCLUDES.dup
        )
      end

      def create
        new_event = Event.new
        new_event.event_time = event_time
        new_event.event_type = event_type
        new_event.venue = Venue.find(venue_id)
        new_event.orchestra = Orchestra.find(orchestra_id)

        new_event.save!

        render json: EventSerializer.new(
          new_event
        ), status: :created
      end

      def update
        event = Event.find(params[:id])

        attributes = params.require(:data)
                           .require(:attributes)

        venue = Venue.find(venue_id) if params[:data][:relationships].key?(:venue)
        orchestra = Orchestra.find(orchestra_id) if params[:data][:relationships].key?(:orchestra)

        event.event_time = attributes[:event_time].to_datetime if attributes.key?(:event_time)
        event.event_type = attributes[:event_type] if attributes.key?(:event_type)
        event.venue = venue if venue.present?
        event.orchestra = orchestra if orchestra.present?
        event.save!

        render json: VenueSerializer.new(venue)
      end

      def destroy
        event = Event.find(params[:id])
        event.destroy!
        head 204
      end

      private

      def venue_id
        params.require(:data).require(:relationships).require(:venue).require(:data).require(:id)
      end

      def orchestra_id
        params.require(:data).require(:relationships).require(:orchestra).require(:data).require(:id)
      end

      def event_time
        params.require(:data).require(:attributes).require(:event_time)
      end

      def event_type
        params.require(:data).require(:attributes).require(:event_type)
      end
    end
  end
end
