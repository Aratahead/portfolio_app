class AddAddColumnPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :review_date, :datetime
    add_column :posts, :review_completion, :integer
  end
end
