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

  path '/orchestras' do
    post 'Add an orchestra' do
      tags 'Orchestras'
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
                  name: { type: :string }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      response '201', 'Orchestra created' do
        context 'normal run' do
          let!(:orchestra) { create(:orchestra) }

          context 'when adding a valid orchestra' do
            let(:payload) { valid_attributes }

            run_test!
          end
        end
      end
    end

    get 'Listing orchestras' do
      tags 'Orchestras'
      produces 'application/json'
      document_index_parameters ::V1::Indexes::Orchestra
      security [oauth2: []]

      response '200', 'listing orchestras' do
        context 'normal operation' do
          let!(:orchestra1) { create(:orchestra) }
          let!(:orchestra2) { create(:orchestra) }

          context 'orchestras are listed' do
            run_test! do
              expect(data).to contain_exactly(
                a_hash_including(id: orchestra1.id),
                                a_hash_including(id: orchestra2.id)
                              )
            end
          end
        end
      end
    end
  end

  path '/orchestras/{id}' do
    get 'Show orchestra' do
      tags 'Orchestras'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let!(:orchestra) { create(:orchestra) }
      let(:id) { orchestra.id }

      response '200', 'show orchestra' do
        run_test! do
          expect(data[:id]).to eq(orchestra.id)
        end
      end
    end

    patch 'Update orchestra' do
      tags 'Orchestras'
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
                  name: { type: :string }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      let!(:orchestra_to_update) { create(:orchestra) }
      let(:id) { orchestra_to_update.id }

      let!(:payload) do
        {
          data: {
            attributes: {
              name: 'new-orchestra-name'
            }
          }
        }
      end

      response '200', 'User updated' do
        run_test! do
          expect(orchestra_to_update.reload).to have_attributes(
            name: eq('new-orchestra-name'))
        end
      end
    end

    delete 'Remove orchestra' do
      tags 'Orchestras'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let(:id) { orchestra1.id }

      response '204', 'Orchestra deleted' do
        let!(:orchestra1) { create(:orchestra) }
        let!(:orchestra2) { create(:orchestra) }

        run_test! do
          expect(Orchestra.exists?(orchestra1.id)).to be false
          expect(orchestra2.reload).to_not be_nil
        end
      end
    end
  end

  def valid_attributes(name: 'The Big Orchestra')
    {
      data: {
        attributes: {
          name: name
        }
      }
    }
  end
end
