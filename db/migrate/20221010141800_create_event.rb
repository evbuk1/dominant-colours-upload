# frozen_string_literal: true

class CreateEvent < ActiveRecord::Migration[7.0]
  def change
    create_table :events, id: :uuid do |t|
      t.datetime :event_time
      t.string :event_type
      t.references :venue, foreign_key: true, type: :uuid
      t.references :artist, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
