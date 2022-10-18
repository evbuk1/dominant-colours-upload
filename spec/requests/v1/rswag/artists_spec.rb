# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Artists', type: :request do
  RSpec::Matchers.define_negated_matcher :excluding, :include
  let!(:user) { create(:user) }

  let(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id).token }
  let(:Authorization) { "Bearer #{access_token}" }

  let(:json) { JSON(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  define_negated_matcher :not_eq, :eq

  path '/artists' do
    post 'Add an artist' do
      tags 'Artists'
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
                required: %i[name],
                properties: {
                  name: { type: :string },
                  twitter: { type: :string },
                  facebook: { type: :string },
                  website: { type: :string },
                  genre: { type: :string }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      response '201', 'Artist created' do
        context 'normal run' do
          let!(:artist) { create(:artist) }

          context 'when adding a valid orchestra' do
            let(:payload) { valid_attributes }

            run_test!
          end
        end
      end
    end

    get 'Listing artists' do
      tags 'Artists'
      produces 'application/json'
      document_index_parameters ::V1::Indexes::Artist
      security [oauth2: []]

      response '200', 'listing artists' do
        context 'normal operation' do
          let!(:artist1) { create(:artist) }
          let!(:artist2) { create(:artist) }

          context 'artists are listed' do
            run_test! do
              expect(data).to contain_exactly(
                a_hash_including(id: artist1.id),
                                a_hash_including(id: artist2.id)
                              )
            end
          end
        end
      end
    end
  end

  path '/artists/{id}' do
    get 'Show artist' do
      tags 'Artists'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let!(:artist) { create(:artist) }
      let(:id) { artist.id }

      response '200', 'show artist' do
        run_test! do
          expect(data[:id]).to eq(artist.id)
        end
      end
    end

    patch 'Update artist' do
      tags 'Artists'
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
                  name: { type: :string },
                  twitter: { type: :string },
                  facebook: { type: :string },
                  website: { type: :string },
                  genre: { type: :string }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      let!(:artist_to_update) { create(:artist) }
      let(:id) { artist_to_update.id }

      let!(:payload) do
        {
          data: {
            attributes: {
              name: 'new-artist-name'
            }
          }
        }
      end

      response '200', 'Artist updated' do
        run_test! do
          expect(artist_to_update.reload).to have_attributes(
            name: eq('new-artist-name'))
        end
      end
    end

    delete 'Remove artist' do
      tags 'Artists'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let(:id) { artist1.id }

      response '204', 'Artist deleted' do
        let!(:artist1) { create(:artist) }
        let!(:artist2) { create(:artist) }

        run_test! do
          expect(Artist.exists?(artist1.id)).to be false
          expect(artist2.reload).to_not be_nil
        end
      end
    end
  end

  def valid_attributes(name: 'The Big Artist', facebook: 'artist-facebook', twitter: 'artist-twitter', website: 'artist-website', genre: 'Rock')
    {
      data: {
        attributes: {
          name: name,
          facebook: facebook,
          twitter: twitter,
          website: website,
          genre: genre
        }
      }
    }
  end
end
