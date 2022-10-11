# frozen_string_literal: true

class CreateLocation < ActiveRecord::Migration[7.0]
  def change
    create_table :locations, id: :uuid do |t|
      t.string :city
      t.string :state
      t.timestamps
    end

    add_index :locations, %i[city state], unique: true
  end
end
