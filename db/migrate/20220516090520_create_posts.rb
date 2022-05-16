class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :question_name
      t.text :code
      t.text :comment
      t.integer :user_id

      t.timestamps
    end
  end
end
