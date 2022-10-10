class CreateEvent < ActiveRecord::Migration[7.0]
  def change
    create_table :events, id: :uuid do |t|
      t.time :time
      t.string :type
      t.references :venue, foreign_key: true, type: :uuid
      t.references :orchestra, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
