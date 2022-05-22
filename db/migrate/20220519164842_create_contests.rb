# frozen_string_literal: true

class CreateContests < ActiveRecord::Migration[6.1]
  def change
    create_table :contests do |t|
      t.string :contest_name
      t.integer :contest_number

      t.timestamps
    end
  end
end
