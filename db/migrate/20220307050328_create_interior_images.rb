class CreateInteriorImages < ActiveRecord::Migration[5.2]
  def change
    create_table :interior_images do |t|
      t.integer :interior_id
      t.string :image_id
      t.index [:interior_id], name: "index_interior_images_on_interior_id"
      
      t.timestamps
    end
  end
end
