class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :url
      t.datetime :publication_date
      t.belongs_to :author
      t.belongs_to :picture_thread
      t.timestamps
    end
  end
end
