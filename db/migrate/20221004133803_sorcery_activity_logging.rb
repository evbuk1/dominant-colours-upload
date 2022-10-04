# frozen_string_literal: true

class SorceryActivityLogging < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_login_at,     :datetime, default: nil
    add_column :users, :last_logout_at,    :datetime, default: nil
    add_column :users, :last_activity_at,  :datetime, default: nil
    add_column :users, :sign_in_count,     :integer, default: 0, null: false
    add_column :users, :last_login_from_ip_address, :string, default: nil

    add_index :users, %i[last_logout_at last_activity_at]
  end
end