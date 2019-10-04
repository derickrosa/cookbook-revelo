class RecipeList < ApplicationRecord

  validates :name, uniqueness: { scope: :user, message: 'Lista já existe!'}
  belongs_to :user
  has_many :recipe_list_items
  has_many :recipes, through: :recipe_list_items

  def owned?(current_user)
    self.user == current_user
  end
end
