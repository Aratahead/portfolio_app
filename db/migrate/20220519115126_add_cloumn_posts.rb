# frozen_string_literal: true

class AddCloumnPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :correct, :integer, null: false
  end
end
