class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :avatar_url, :string
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
