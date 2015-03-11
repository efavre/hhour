class RenamePictureThreadsToChallenges < ActiveRecord::Migration
  def change
    remove_index "picture_threads_users", ["picture_thread_id", "user_id"]

    rename_table :picture_threads, :challenges
    rename_table :picture_threads_users, :challenges_users

    rename_column :pictures, :picture_thread_id, :challenge_id
    rename_column :challenges_users, :picture_thread_id, :challenge_id

    add_index "challenges_users", ["challenge_id", "user_id"], name: "index_challenges_users_on_challenge_id_and_user_id"
  end
end
