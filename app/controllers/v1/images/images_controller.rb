# frozen_string_literal: true

module V1
  module Images
    class ImagesController < BaseController

      def index
        images_index = make_index(Indexes::Image, Image.all)
        render json: ImageSerializer.new(
          images_index.filtered,
          images_index.options
        )
      end

      def show
        image = Image.find(params[:id])
        render json: ImageSerializer.new(
          image,
          include: Indexes::Image::INCLUDES.dup
        )
      end

      def create
        new_image = Image.new(image_params)
        new_image.save!

        render json: ImageSerializer.new(
          new_image
        ), status: :created
      end

      def update
        image = Image.find(params[:id])

        attributes = params.require(:data)
                           .require(:attributes)

        return head 400 unless attributes.key?(:elbow_plot) ||
                               attributes.key?(:image) ||
                               attributes.key?(:clustered_image) ||
                               attributes.key?(:rgb_colours) ||
                               attributes.key?(:hex_colours) ||
                               attributes.key?(:num_clusters)

        image.update!(attributes.permit(:elboe_plot, :image, :clustered_image, :rgb_colours, :hex_colours, :num_clusters).to_h.compact)

        render json: ImageSerializer.new(image)
      end

      def destroy
        image = Image.find(params[:id])
        image.destroy!
        head 204
      end

      private

      def image_params
        params.require(:data).require(:attributes).permit(:elbow_plot, :image, :clustered_image, :rgb_colours, :hex_colours, :num_clusters)
      end
    end
  end
end
