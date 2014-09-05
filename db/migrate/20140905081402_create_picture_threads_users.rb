class CreatePictureThreadsUsers < ActiveRecord::Migration
  def change
    create_table :picture_threads_users do |t|
      t.integer :picture_thread_id
      t.integer :user_id
      t.timestamps
    end
    add_index :picture_threads_users, [:picture_thread_id, :user_id]
  end

end
