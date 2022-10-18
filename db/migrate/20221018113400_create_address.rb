# frozen_string_literal: true

class CreateAddress < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses, id: :uuid do |t|
      t.references :venue, foreign_key: true, type: :uuid
      t.string :address1
      t.string :address2
      t.string :address3
      t.timestamps
    end
  end
end
