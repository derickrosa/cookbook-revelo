# frozen_string_literal: true

class Api::V1::RecipesController < ActionController::API
  def index
    render json: Recipe.where(params.permit(:status, :cuisine)), status: :ok
    # return render json: Recipe.all unless  params[:status]
    # render json: Recipe.method(params[:status].to_sym)
  end
end
