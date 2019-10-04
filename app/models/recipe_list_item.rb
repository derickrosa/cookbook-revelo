class RecipeListItem < ApplicationRecord
  belongs_to :recipe_list
  belongs_to :recipe
end
