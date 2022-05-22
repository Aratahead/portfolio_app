# frozen_string_literal: true

class AddColumnPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :contest, foreign_key: true
  end
end
