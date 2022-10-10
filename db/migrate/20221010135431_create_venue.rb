# frozen_string_literal: true

class CreateVenue < ActiveRecord::Migration[7.0]
  def change
    create_table :venues, id: :uuid do |t|
      t.references :location, foreign_key: true, type: :uuid
      t.string :name, unique: true
      t.timestamps
    end
  end
end
