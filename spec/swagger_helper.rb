# frozen_string_literal: true

require 'rails_helper'

def all_properties_required(h)
  h.merge(required: h[:properties].keys)
end

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:to_swagger' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'

  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'Dominant Colours Operation API',
        version: 'v1'
      },
      basePath: '/v1',
      definitions: {
        image: {
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                attributes: {
                  type: :object,
                  required: %i[image],
                  properties: {
                    elbow_plot: { type: :string },
                    image: { type: :string },
                    clustered_image: { type: :string },
                    rgb_colours: { type: :string },
                    hex_colours: { type: :string },
                    num_clusters: { type: :string }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
end

module Rswag
  module Specs
    module ExampleGroupHelpers
      FILTER_OP_DESCRIPTIONS = {
        contains: 'contains the given value as a substring (case-insensitive)',
        lt: 'is strictly less than the given value',
        lte: 'is less than or equal to the given value',
        gt: 'is strictly greater than the given value',
        gte: 'is greater than or equal to the given value',
        ne: 'is not equal to the given value',
        nil => 'is equal to the given value'
      }.freeze

      def extra_opts(key)
        { }
      end

      def document_filter_parameter(key, opts)
        if opts == { in: [] }
          parameter name: "filter[#{key}][in][]",
                    in: :query,
                    type: :array,
                    items: { type: :string, **extra_opts(key) },
                    collectionFormat: :multi,
                    required: false,
                    description: "Causes the response to include only records whose `#{key}` attribute is equal to one of the given values."
        elsif opts.nil? || opts.is_a?(Symbol)
          desc = FILTER_OP_DESCRIPTIONS.fetch(opts)
          raise "missing doc for filter operator: #{opts}" unless desc

          parameter name: "filter[#{key}]" + (opts.nil? ? '' : "[#{opts}]"),
                    in: :query,
                    type: :string,
                    required: false,
                    description: "Causes the response to include only records whose `#{key}` attribute #{desc}.",
                    **extra_opts(key)
        else
          raise "don't know how to document key=#{key} opts=#{opts.inspect}"
        end
      end

      def document_index_parameters(index_class)
        sortable_fields = index_class::SORTABLE_FIELDS.map { |f| "`#{f}`" }.join(', ')
        parameter name: :sort, in: :query, type: :string, required: false, description: "Comma-separated list of fields to sort by. Available fields: #{sortable_fields}. Prefix a field by `-` to reverse the sort order. For example `foo,-bar` sorts by `foo` in ascending order then by `bar` in descending order."
        index_class::FILTERABLE_FIELDS.each do |filter|
          if filter.is_a?(Hash)
            filter.each do |key, ops|
              ops.each do |op|
                document_filter_parameter(key, op)
              end
            end
          else
            document_filter_parameter(filter, nil)
          end
        end
      end
    end
  end
end
