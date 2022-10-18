# frozen_string_literal: true

class CreateLocation < ActiveRecord::Migration[7.0]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :ward
      t.string :borough
      t.timestamps
    end

    add_index :locations, %i[ward borough], unique: true
  end
end
