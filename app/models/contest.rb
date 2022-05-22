# frozen_string_literal: true

class Contest < ApplicationRecord
  has_many :posts, dependent: :destroy
end
