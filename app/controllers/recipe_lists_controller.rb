class RecipeListsController < ApplicationController
  def new
    @recipe_list = RecipeList.new
  end

  def create
    @recipe_list = current_user.recipe_lists.new(params.require(:recipe_list).permit(:name))

    if @recipe_list.save()
      redirect_to list_path(@recipe_list)
    else
      render :new
    end
  end

  def my_lists
    @recipe_lists = RecipeList.where(user: current_user)
  end

  def show
    @recipe_list = RecipeList.find(params[:id])
  end
end