class AddAddColumnPosts < ActiveRecord::Migration[6.1]
  def change
    change_table :posts, bulk: true do |t|
      t.datetime :review_date
      t.integer :review_completion, default: 0
    end
  end
end
