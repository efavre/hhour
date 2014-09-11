class AddFileKeyToPictures < ActiveRecord::Migration
  def change
  	add_column :pictures, :fileKey, :string
  end
end
