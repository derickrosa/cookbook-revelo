class Recipe < ApplicationRecord
  belongs_to :recipe_type
  belongs_to :user
  has_many :recipe_list_items
  has_many :recipe_lists, through: :recipe_list_items
  enum status: { pending: 0, approved: 10 }

  validates :title, :cuisine, :difficulty, :cook_time, :ingredients, :cook_method, presence: {message: 'Campo em branco!'}

  def cook_time_minutes
    "#{cook_time} minutos"
  end
end
