class AddPrivateArticleLimitToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :private_articles_remaining, :integer, default: 5
  end
end
