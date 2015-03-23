class ChangeUsersColumnFirstNameToFacebookName < ActiveRecord::Migration
  def change
    rename_column :users, :first_name, :facebook_name
  end
end
