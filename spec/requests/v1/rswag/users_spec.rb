# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users', type: :request do
  RSpec::Matchers.define_negated_matcher :excluding, :include
  let!(:user) { create(:user) }

  let(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id).token }
  let(:Authorization) { "Bearer #{access_token}" }

  let(:json) { JSON(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  path '/users/users' do
    get 'Listing users' do
      tags 'Users'
      produces 'application/json'
      document_index_parameters ::V1::Indexes::User
      security [oauth2: []]


      response '200', 'listing users' do
        context 'normal operation' do
          let!(:user1) { create(:user) }
          let!(:user2) { create(:user) }

          context 'users are listed' do
            run_test! do
              expect(data).to contain_exactly(
                                a_hash_including(id: user.id),
                                a_hash_including(id: user1.id),
                                a_hash_including(id: user2.id)
                              )
            end
          end
        end
      end
    end
  end
end
