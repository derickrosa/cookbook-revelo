class RecipeList < ApplicationRecord
  validates :name, uniqueness: { scope: :user, message: 'Lista já existe!'}
  belongs_to :user
end
