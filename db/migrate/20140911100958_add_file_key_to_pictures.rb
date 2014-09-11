class AddFileKeyToPictures < ActiveRecord::Migration
  def up
  	add_column :pictures, :file_key, :string
  end

  def down
  	remove_column :pictures, :fileKey, :string
  end
end
