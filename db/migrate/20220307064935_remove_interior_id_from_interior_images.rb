class RemoveInteriorIdFromInteriorImages < ActiveRecord::Migration[5.2]
  def change
    remove_column :interior_images, :interior_id, :integer
  end
end
