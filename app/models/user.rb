class User < ApplicationRecord
  include Filterable
  include Sortable

  authenticates_with_sorcery!

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :destroy
end
