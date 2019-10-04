class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update]
  before_action :set_recipe, only: %i[show edit update]
  before_action :set_recipe_type, only: %i[new edit]
  before_action :own_recipe?, only: [:edit, :update]

  def index
    @recipes = Recipe.all
  end

  def show
    if current_user
      @recipe_lists = current_user.recipe_lists
    end
  end

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

  def my_recipes
    @recipes = Recipe.where(user: current_user)
  end
  
  def add_to_list
    @recipe_list = RecipeList.find(params[:recipe_list])
    @recipe = Recipe.find(params[:id])

    return redirect_to root_path unless @recipe_list.owned?(current_user)
    
    if @recipe_list.recipes.find_by(id: @recipe.id)
      flash[:notice] = 'Receita já adicionada a esta lista!'      
      redirect_to @recipe
    else
      @recipe_list_item = RecipeListItem.create!(recipe: @recipe, recipe_list: @recipe_list)
      redirect_to @recipe_list
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

  def own_recipe?
    redirect_to root_path unless @recipe.user == current_user
  end
end
