class ChangeUsersFacebookOauthTokenColumn < ActiveRecord::Migration
  def change
    rename_column :users, :facebook_oauth_token, :facebook_token
  end
end
