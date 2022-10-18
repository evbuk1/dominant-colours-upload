# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Events', type: :request do
  RSpec::Matchers.define_negated_matcher :excluding, :include
  let!(:user) { create(:user) }

  let(:access_token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id).token }
  let(:Authorization) { "Bearer #{access_token}" }

  let(:json) { JSON(response.body, symbolize_names: true) }
  let(:data) { json[:data] }

  define_negated_matcher :not_eq, :eq

  path '/events' do
    post 'Add an event' do
      tags 'Events'
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
                required: %i[event_time event_type],
                properties: {
                  event_time: { type: :string },
                  event_type: { type: :string }
                }
              }
            }
          },
          relationships: {
            type: :object,
            required: %i[location],
            properties: {
              venue: {
                type: :object,
                properties: {
                  data: {
                    type: :object,
                    properties: {
                      id: { type: :string, format: :uuid }
                    }
                  }
                }
              },
              artist: {
                type: :object,
                properties: {
                  data: {
                    type: :object,
                    properties: {
                      id: { type: :string, format: :uuid }
                    }
                  }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      response '201', 'Event created' do
        context 'normal run' do
          let!(:artist1) { create(:artist) }
          let!(:venue1) { create(:venue) }

          context 'when adding a valid event' do
            let(:payload) { valid_payload }

            run_test!
          end
        end
      end
    end

    get 'Listing events' do
      tags 'Events'
      produces 'application/json'
      document_index_parameters ::V1::Indexes::Event
      security [oauth2: []]

      response '200', 'listing events' do
        context 'normal operation' do
          let!(:event1) { create(:event) }
          let!(:event2) { create(:event) }

          context 'events are listed' do
            run_test! do
              expect(data).to contain_exactly(
                a_hash_including(id: event1.id),
                                a_hash_including(id: event2.id)
                              )
            end
          end
        end
      end
    end
  end

  path '/events/{id}' do
    get 'Show event' do
      tags 'Events'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let!(:event) { create(:event) }
      let(:id) { event.id }

      response '200', 'show event' do
        run_test! do
          expect(data[:id]).to eq(event.id)
        end
      end
    end

    patch 'Update event' do
      tags 'Events'
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
                  event_time: { type: :string },
                  event_type: { type: :string }
                }
              }
            }
          },
          relationships: {
            type: :object,
            properties: {
              venue: {
                type: :object,
                properties: {
                  data: {
                    type: :object,
                    properties: {
                      id: { type: :string, format: :uuid }
                    }
                  }
                }
              },
              artist: {
                type: :object,
                properties: {
                  data: {
                    type: :object,
                    properties: {
                      id: { type: :string, format: :uuid }
                    }
                  }
                }
              }
            }
          }
        }
      }
      security [oauth2: []]

      let!(:event_to_update) { create(:event) }
      let!(:new_time) { Time.new(2020, 1, 1) }
      let!(:new_venue) { create(:venue) }
      let!(:new_artist) { create(:artist) }

      let(:id) { event_to_update.id }

      let!(:payload) do
        {
          data: {
            attributes: {
              event_time: new_time,
              event_type: 'new-type'
            },
            relationships: {
              venue: {
                data: {
                  id: new_venue.id
                }
              },
              artist: {
                data: {
                  id: new_artist.id
                }
              }
            }
          }
        }
      end

      response '200', 'Event updated' do
        run_test! do
          expect(event_to_update.reload).to have_attributes(
            event_type: eq('new-type'),
            event_time: eq(new_time))
          expect(event_to_update.venue).to eq(new_venue)
          expect(event_to_update.artist).to eq(new_artist)
        end
      end
    end

    delete 'Remove event' do
      tags 'Events'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, format: :uuid
      security [oauth2: []]

      let(:id) { event1.id }

      response '204', 'Event deleted' do
        let!(:event1) { create(:event) }
        let!(:event2) { create(:event) }

        run_test! do
          expect(Event.exists?(event1.id)).to be false
          expect(event2.reload).to_not be_nil
        end
      end
    end
  end

  def valid_payload
    {
      data: {
        attributes: {
          event_type: 'new-type',
          event_time: Time.now
        },
        relationships: {
          venue: {
            data: {
              id: venue1.id
            }
          },
          artist: {
            data: {
              id: artist1.id
            }
          }
        }
      }
    }
  end
end
