class RecipeTypesController < ApplicationController
  before_action :set_recipe_type, only: %i[show]
  before_action :set_recipe_type_params, only: %i[create]

  def new
    @recipe_type = RecipeType.new
  end

  def create    
    @duplicated = RecipeType.find_by(name: set_recipe_type_params[:name])

    if @duplicated
      flash[:notice] = 'Tipo de receita já cadastrada'
      return redirect_to new_recipe_type_path
    end

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