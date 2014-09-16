class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :token
      t.belongs_to :user
      t.timestamps
    end
  end
end
