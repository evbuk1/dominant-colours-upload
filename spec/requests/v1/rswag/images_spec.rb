# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Images', type: :request do
  RSpec::Matchers.define_negated_matcher :excluding, :include

  let(:json) { JSON(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  define_negated_matcher :not_eq, :eq

  path '/images' do
    post 'Upload an image' do
      tags 'Images'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :payload, in: :body, required: true, schema: { '$ref' => '#/definitions/image' }

      response '201', 'Image uploaded' do
        context 'normal run' do
          let!(:image) { create(:image) }

          context 'when adding a valid image' do
            let(:payload) { valid_attributes }

            run_test!
          end
        end
      end
    end

    get 'Listing images' do
      tags 'Images'
      produces 'application/json'
      document_index_parameters ::V1::Indexes::Image

      response '200', 'listing images' do
        context 'normal operation' do
          let!(:image1) { create(:image) }
          let!(:image2) { create(:image) }

          context 'images are listed' do
            run_test! do
              expect(data).to contain_exactly(
                a_hash_including(id: image1.id.to_s),
                a_hash_including(id: image2.id.to_s)
              )
            end
          end
        end
      end
    end
  end

  path '/images/{id}' do
    get 'Show image' do
      tags 'Images'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      let!(:image) { create(:image) }
      let(:id) { image.id }

      response '200', 'show image' do
        run_test! do
          expect(data[:id]).to eq(image.id.to_s)
        end
      end
    end

    patch 'Update image' do
      tags 'Images'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :payload, in: :body, required: true, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              attributes: {
                type: :object,
                properties: {
                  elbow_plot: { type: :string },
                  image: { type: :string },
                  clustered_image: { type: :string },
                  rgb_colours: { type: :string },
                  hex_colours: { type: :string },
                  num_clusters: { type: :integer }
                }
              }
            }
          }
        }
      }

      let!(:image_to_update) { create(:image) }
      let(:id) { image_to_update.id }

      let!(:payload) do
        {
          data: {
            attributes: {
              clustered_image: 'path-to-clustered-image'
            }
          }
        }
      end

      response '200', 'Image updated' do
        run_test! do
          expect(image_to_update.reload).to have_attributes(
                                              clustered_image: eq('path-to-clustered-image'))
        end
      end
    end

    delete 'Remove image' do
      tags 'Images'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :id

      let(:id) { image1.id }

      response '204', 'Artist deleted' do
        let!(:image1) { create(:image) }
        let!(:image2) { create(:image) }

        run_test! do
          expect(Image.exists?(image1.id)).to be false
          expect(image2.reload).to_not be_nil
        end
      end
    end
  end

  def valid_attributes(elbow_plot: 'path-to-elbow-plot', image: 'path-to-image', clustered_image: 'path-to-clustered-image', rgb_colours: '[333, 222, 111]', hex_colours: '[#FFFFFF, #000000, #F3C4D5]')
    {
      data: {
        attributes: {
          elbow_plot: elbow_plot,
          image: image,
          clustered_image: clustered_image,
          rgb_colours: rgb_colours,
          hex_colours: hex_colours,
          num_clusters: 5
        }
      }
    }
  end
end
