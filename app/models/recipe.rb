class Recipe < ApplicationRecord
  belongs_to :recipe_type
  belongs_to :user
  has_many :recipe_list_items
  has_many :recipe_lists, through: :recipe_list_items
  enum status: { pending: 0, approved: 10, reproved: 20 }

  validates :title, :cuisine, :difficulty, :cook_time, :ingredients, :cook_method, presence: {message: 'Campo em branco!'}

  def cook_time_minutes
    "#{cook_time} minutos"
  end

  def as_json(options = {})
    super(options.merge(include: [:recipe_type, :user], except: [:recipe_type_id, :user_id]))
  end
end
