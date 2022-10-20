# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Venues', type: :request do
  RSpec::Matchers.define_negated_matcher :excluding, :include
  let!(:user) { create(:user) }

  let(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id).token }
  let(:Authorization) { "Bearer #{access_token}" }

  let(:json) { JSON(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  define_negated_matcher :not_eq, :eq

  path '/venues' do
    post 'Add a venue' do
      tags 'Venues'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :payload, in: :body, required: true, schema: { '$ref' => '#/definitions/venue' }
      security [oauth2: []]

      response '201', 'Venue created' do
        context 'normal run' do
          let!(:location1) { create(:location) }

          context 'when adding a valid venue' do
            let(:payload) { valid_payload }

            run_test!
          end
        end
      end
    end

    get 'Listing venues' do
      tags 'Venues'
      produces 'application/json'
      document_index_parameters ::V1::Indexes::Venue
      security [oauth2: []]

      response '200', 'listing venues' do
        context 'normal operation' do
          let!(:venue1) { create(:venue) }
          let!(:venue2) { create(:venue) }

          context 'venues are listed' do
            run_test! do
              expect(data).to contain_exactly(
                a_hash_including(id: venue1.id),
                                a_hash_including(id: venue2.id)
                              )
            end
          end
        end
      end
    end
  end

  path '/venues/{id}' do
    get 'Show venue' do
      tags 'Venues'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let!(:venue) { create(:venue) }
      let(:id) { venue.id }

      response '200', 'show venue' do
        run_test! do
          expect(data[:id]).to eq(venue.id)
        end
      end
    end

    patch 'Update venue' do
      tags 'Venues'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      parameter name: :payload, in: :body, required: true, schema: { '$ref' => '#/definitions/venue' }
      security [oauth2: []]

      let!(:venue_to_update) { create(:venue) }
      let!(:new_location) { create(:location) }
      let(:id) { venue_to_update.id }

      let!(:payload) do
        {
          data: {
            attributes: {
              name: 'new-venue-name'
            },
            relationships: {
              location: {
                data: {
                  id: new_location.id
                }
              }
            }
          }
        }
      end

      response '200', 'Venue updated' do
        run_test! do
          expect(venue_to_update.reload).to have_attributes(
            name: eq('new-venue-name'))
          expect(venue_to_update.location).to eq(new_location)
        end
      end
    end

    delete 'Remove venue' do
      tags 'Venues'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let(:id) { venue1.id }

      response '204', 'Venue deleted' do
        let!(:venue1) { create(:venue) }
        let!(:venue2) { create(:venue) }

        run_test! do
          expect(Venue.exists?(venue1.id)).to be false
          expect(venue2.reload).to_not be_nil
        end
      end
    end
  end

  def valid_payload(name: 'The Big Venue')
    {
      data: {
        attributes: {
          name: name
        },
        relationships: {
          location: {
            data: {
              id: location1.id
            }
          }
        }
      }
    }
  end
end
