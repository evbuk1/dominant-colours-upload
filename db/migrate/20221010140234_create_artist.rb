# frozen_string_literal: true

class CreateArtist < ActiveRecord::Migration[7.0]
  def change
    create_table :artists, id: :uuid do |t|
      t.string :name
      t.string :website
      t.string :facebook
      t.string :twitter
      t.string :genre
      t.timestamps
    end
  end
end
