class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :elbow_plot
      t.string :image
      t.text :clustered_image, limit: 4_294_967_295
      t.string :rgb_colours
      t.string :hex_colours
      t.integer :num_clusters
      t.timestamps
    end
  end
end
