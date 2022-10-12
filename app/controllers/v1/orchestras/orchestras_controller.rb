# frozen_string_literal: true

module V1
  module Orchestras
    class OrchestrasController < BaseController

      def index
        orchestras_index = make_index(Indexes::Orchestra, Orchestra.all)
        render json: OrchestraSerializer.new(
          orchestras_index.filtered,
          orchestras_index.options
        )
      end

      def show
        orchestra = Orchestra.find(params[:id])
        render json: OrchestraSerializer.new(
          orchestra,
          include: Indexes::Orchestra::INCLUDES.dup
        )
      end

      def create
        new_orchestra = Orchestra.new(orchestra_params)
        new_orchestra.save!

        render json: OrchestraSerializer.new(
          new_orchestra
        ), status: :created
      end

      def update
        orchestra = Orchestra.find(params[:id])

        attributes = params.require(:data)
                           .require(:attributes)

        return head 400 unless attributes.key?(:name)

        orchestra.update!(attributes.permit(:name).to_h.compact)

        render json: OrchestraSerializer.new(orchestra)
      end

      def destroy
        orchestra = Orchestra.find(params[:id])
        orchestra.destroy!
        head 204
      end

      private

      def orchestra_params
        params.require(:data).require(:attributes).permit(:name)
      end
    end
  end
end
