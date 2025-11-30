class AddProfileFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    add_column :users, :avatar_url, :string
    add_column :users, :profile, :text
  end
end
