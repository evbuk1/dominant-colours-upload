# frozen_string_literal: true

module V1
  module Artists
    class ArtistsController < BaseController

      def index
        artists_index = make_index(Indexes::Artist, Artist.all)
        render json: ArtistSerializer.new(
          artists_index.filtered,
          artists_index.options
        )
      end

      def show
        artist = Artist.find(params[:id])
        render json: ArtistSerializer.new(
          artist,
          include: Indexes::Artist::INCLUDES.dup
        )
      end

      def create
        new_artist = Artist.new(artist_params)
        new_artist.save!

        render json: ArtistSerializer.new(
          new_artist
        ), status: :created
      end

      def update
        artist = Artist.find(params[:id])

        attributes = params.require(:data)
                           .require(:attributes)

        return head 400 unless attributes.key?(:name) ||
                               attributes.key?(:genre) ||
                               attributes.key?(:facebook) ||
                               attributes.key?(:twitter) ||
                               attributes.key?(:website)

        artist.update!(attributes.permit(:name, :genre, :facebook, :twitter, :website).to_h.compact)

        render json: ArtistSerializer.new(artist)
      end

      def destroy
        artist = Artist.find(params[:id])
        artist.destroy!
        head 204
      end

      private

      def artist_params
        params.require(:data).require(:attributes).permit(:name, :genre, :facebook, :twitter, :website)
      end
    end
  end
end
