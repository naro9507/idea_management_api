class Idea < ApplicationRecord
  belongs_to :categories, optional: true

  validates :category_id, presence: true, numericality: {only_integer: true}
  validates :body, presence: true
end
