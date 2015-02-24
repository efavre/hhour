class AddFacebookIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :facebook_id, :string
  	add_column :users, :facebook_oauth_token, :string
  end
end
