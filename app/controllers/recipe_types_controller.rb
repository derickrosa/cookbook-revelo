class RecipeTypesController < ApplicationController
  before_action :set_recipe_type, only: %i[show]

  def new
    @recipe_type = RecipeType.new
  end

  def create
    @recipe_type = RecipeType.new(set_recipe_type_params)
    if @recipe_type.save
      redirect_to @recipe_type
    else
      render :new
    end
  end

  def show
    @recipes = Recipe.where(recipe_type: @recipe_type)
  end

  def index
    @recipe_types = RecipeType.all
  end

  private
  def set_recipe_type
    @recipe_type = RecipeType.find(params[:id])
  end
  def set_recipe_type_params
    params.require(:recipe_type).permit(:name)
  end

end