# frozen_string_literal: true

class Api::V1::RecipesController < ActionController::API
  def index
    render json: Recipe.where(params.permit(:status, :cuisine)), status: :ok
    # return render json: Recipe.all unless  params[:status]
    # render json: Recipe.method(params[:status].to_sym)
  end

  def show
    render json: Recipe.find(params[:id]), status: :ok
  rescue
    render json: { error: 'Receita não encontrada!' }, status: :not_found
  end

  def create
    @recipe = Recipe.new(params.permit(:title, :cuisine, :recipe_type_id, :ingredients, :user_id,
                                       :cook_time, :cook_method, :difficulty, :status))
    if @recipe.save
      render json: @recipe, status: :ok
    else
      render json: { error: 'Todos os campos são obrigatórios' }, status: :unprocessable_entity
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      return render json: @recipe, status: :ok
    else
      return render json: { message: 'Parâmetros inconsistentes!' }, status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :cuisine, :recipe_type_id,
                                   :ingredients, :user_id, :cook_time,
                                   :cook_method, :difficulty, :status)
  end
end
