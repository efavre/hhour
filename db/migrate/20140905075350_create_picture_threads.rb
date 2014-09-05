class CreatePictureThreads < ActiveRecord::Migration
  def change
    create_table :picture_threads do |t|
      t.string :title
      t.datetime :closing_date
      t.belongs_to :author
      t.timestamps
    end
  end
end
