# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Locations', type: :request do
  RSpec::Matchers.define_negated_matcher :excluding, :include
  let!(:user) { create(:user) }

  let(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id).token }
  let(:Authorization) { "Bearer #{access_token}" }

  let(:json) { JSON(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  define_negated_matcher :not_eq, :eq

  path '/locations' do
    post 'Add a location' do
      tags 'Locations'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :payload, in: :body, required: true, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              attributes: {
                type: :object,
                required: %i[city state],
                properties: {
                  ward: { type: :string },
                  borough: { type: :string }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      response '201', 'Location created' do
        context 'normal run' do
          let!(:location) { create(:location) }

          context 'when adding a valid user' do
            let(:payload) { valid_attributes }

            run_test!
          end
        end
      end
    end

    get 'Listing locations' do
      tags 'Locations'
      produces 'application/json'
      document_index_parameters ::V1::Indexes::Location
      security [oauth2: []]

      response '200', 'listing locations' do
        context 'normal operation' do
          let!(:location1) { create(:location) }
          let!(:location2) { create(:location) }

          context 'locations are listed' do
            run_test! do
              expect(data).to contain_exactly(
                a_hash_including(id: location1.id),
                                a_hash_including(id: location2.id)
                              )
            end
          end
        end
      end
    end
  end

  path '/locations/{id}' do
    get 'Show location' do
      tags 'Locations'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let!(:location) { create(:location) }
      let(:id) { location.id }

      response '200', 'show location' do
        run_test! do
          expect(data[:id]).to eq(location.id)
        end
      end
    end

    patch 'Update location' do
      tags 'Locations'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      parameter name: :payload, in: :body, required: true, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              attributes: {
                type: :object,
                properties: {
                  ward: { type: :string },
                  borough: { type: :string }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      let!(:location_to_update) { create(:location) }
      let(:id) { location_to_update.id }

      let!(:payload) do
        {
          data: {
            attributes: {
              ward: 'new-ward',
              borough: 'new-borough'
            }
          }
        }
      end

      response '200', 'Location updated' do
        run_test! do
          expect(location_to_update.reload).to have_attributes(
            ward: eq('new-ward'),
            borough: eq('new-borough'))
        end
      end
    end

    delete 'Remove location' do
      tags 'Locations'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let(:id) { location1.id }

      response '204', 'Location deleted' do
        let!(:location1) { create(:location) }
        let!(:location2) { create(:location) }

        run_test! do
          expect(Location.exists?(location1.id)).to be false
          expect(location2.reload).to_not be_nil
        end
      end
    end
  end

  def valid_attributes(ward: 'An Ward', borough: 'An Borough')
    {
      data: {
        attributes: {
          ward: ward,
          borough: borough
        }
      }
    }
  end
end
