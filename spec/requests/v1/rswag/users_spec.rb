# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users', type: :request do
  RSpec::Matchers.define_negated_matcher :excluding, :include
  let!(:user) { create(:user) }

  let(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id).token }
  let(:Authorization) { "Bearer #{access_token}" }

  let(:json) { JSON(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  define_negated_matcher :not_eq, :eq

  path '/users' do
    post 'Add a user' do
      tags 'Users'
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
                required: %i[first_name last_name email password],
                properties: {
                  first_name: { type: :string },
                  last_name: { type: :string },
                  email: { type: :string },
                  password: {type: :string }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      response '201', 'User created' do
        context 'for a client user with can manage client users permission' do
          let!(:user) { create(:user) }

          context 'when adding a valid user' do
            let(:payload) { valid_attributes }

            run_test!
          end
        end
      end
    end

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

  path '/users/{id}' do
    get 'Show user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let!(:user) { create(:user) }
      let(:id) { user.id }

      response '200', 'show user' do
        run_test! do
          expect(data[:id]).to eq(user.id)
        end
      end
    end

    patch 'Update user' do
      tags 'Users'
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
                  first_name: { type: :string },
                  last_name: { type: :string },
                  email: { type: :string },
                  password: {type: :string }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      let!(:user_to_update) { create(:user) }
      let(:id) { user_to_update.id }

      let!(:payload) do
        {
          data: {
            attributes: {
              first_name: 'new-first-name',
              last_name: 'new-last-name',
              password: 'new-password'
            }
          }
        }
      end

      response '200', 'User updated' do
        let!(:first_name_before_update) { user_to_update.first_name }
        let!(:last_name_before_update) { user_to_update.last_name }
        let!(:salt_before_update) { user_to_update.salt }
        let!(:crypted_password_before_update) { user_to_update.crypted_password }
        run_test! do
          expect(user_to_update.reload).to have_attributes(
            first_name: eq('new-first-name'),
            last_name: eq('new-last-name'),
            salt: not_eq(salt_before_update),
            crypted_password: not_eq(crypted_password_before_update)
          )
        end
      end
    end

    delete 'Remove user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let(:id) { user1.id }

      response '204', 'User deleted' do
        let!(:user1) { create(:user) }
        let!(:user2) { create(:user) }

        run_test! do
          expect(User.exists?(user1.id)).to be false
          expect(user2.reload).to_not be_nil
        end
      end
    end
  end

  def valid_attributes(email: 'first@example.com', first_name: 'first-name', last_name: 'last-name', password: 'password')
    {
      data: {
        attributes: {
          first_name: first_name,
          last_name: last_name,
          email: email,
          password: password,
        }
      }
    }
  end
end

