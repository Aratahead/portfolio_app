class AddCloumnPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :correct, :integer
  end
end
