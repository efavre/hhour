class AddLastingTimeTypeToPictureThreads < ActiveRecord::Migration
  def change
   	add_column :picture_threads, :lasting_time_type, :string, :default => "m"
  end
end
