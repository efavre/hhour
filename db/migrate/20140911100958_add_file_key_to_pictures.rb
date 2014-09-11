class AddFileKeyToPictures < ActiveRecord::Migration
  def change
  	add_column :pictures, :file_key, :string
  end
end
