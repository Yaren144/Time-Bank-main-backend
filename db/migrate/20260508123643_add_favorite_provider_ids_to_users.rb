class AddFavoriteProviderIdsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :favorite_provider_ids, :json
  end
end
