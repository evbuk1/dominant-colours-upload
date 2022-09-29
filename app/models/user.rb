class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :destroy

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :destroy
end
