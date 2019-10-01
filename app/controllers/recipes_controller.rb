class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show edit update]
  before_action :set_recipe_type, only: %i[new edit]

  def index
    @recipes = Recipe.all
  end

  def show; end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    if @recipe.save
      redirect_to @recipe
    else
      @recipe_types = RecipeType.all
      render :new
    end
  end

  def edit; end

  def update
    if @recipe.update(recipe_params)
    redirect_to @recipe
    else
      render :edit
    end
  end

  def search
    @results = Recipe.where("title LIKE ?", "%#{params[:q]}%")
    @query = params[:q]

    if @results.empty?
      @message = "Não foram encontrados resultados para: #{@query}"
    elsif @results.count == 1
      @message = "1 resultado encontrado para: #{@query}"
    else
      @message = "#{@results.count} resultados encontrados para: #{@query}"
    end
  end

  private

  def set_recipe
    @recipe= Recipe.find(params[:id])
    @recipe_types = RecipeType.all
  end

  def set_recipe_type
    @recipe_types = RecipeType.all
  end

  def recipe_params
    params.require(:recipe).permit(:title, :recipe_type_id, :cuisine, :difficulty, :cook_time, :ingredients, :cook_method)
  end
end
