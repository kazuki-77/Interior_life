class AddPostImageIdToInteriorImages < ActiveRecord::Migration[5.2]
  def change
    add_column :interior_images, :post_image_id, :integer
  end
end
