# frozen_string_literal: true

class Contest < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :contest_name, presence: true
  validates :contest_number, precense: true
end
