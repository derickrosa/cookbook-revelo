# frozen_string_literal: true

require 'rails_helper'

describe 'Recipes Api' do
  context 'index' do
    it 'and view multiple recipes' do
      recipe_type = RecipeType.create(name: 'Sobremesa')
      user = User.create!(email: 'teste@teste.com', password: 'teste123')
      recipes = []
      recipes << Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                               recipe_type: recipe_type, cuisine: 'Brasileira',
                               cook_time: 50,
                               ingredients: 'Farinha, açucar, cenoura', user: user,
                               cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                               status: :approved)
      recipes << Recipe.create(title: 'Bolo de chocolate', difficulty: 'Fácil',
                               recipe_type: recipe_type, cuisine: 'Árabe',
                               cook_time: 60,
                               ingredients: 'Farinha, açucar, cenoura', user: user,
                               cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                               status: :approved)
      get api_v1_recipes_path

      json_recipes = JSON.parse(response.body, symbolize_names: true)
      # expect(request.status).to eq 200
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'application/json'
      expect(json_recipes[0][:title]).to eq 'Bolo de cenoura'
      expect(json_recipes[1][:title]).to eq 'Bolo de chocolate'
      # expect(response.body).to include('Bolo de cenoura')
    end

    it 'and view filtered recipes' do
      recipe_type = RecipeType.create(name: 'Sobremesa')
      user = User.create!(email: 'teste@teste.com', password: 'teste123')
      pending_recipe = Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                                     recipe_type: recipe_type, cuisine: 'Brasileira',
                                     cook_time: 50,
                                     ingredients: 'Farinha, açucar, cenoura', user: user,
                                     cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                                     status: :pending)
      approved_recipe = Recipe.create(title: 'Bolo de chocolate', difficulty: 'Fácil',
                                      recipe_type: recipe_type, cuisine: 'Árabe',
                                      cook_time: 60,
                                      ingredients: 'Farinha, açucar, cenoura', user: user,
                                      cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                                      status: :approved)
      other_approved_recipe = Recipe.create(title: 'Bolo de Morango', difficulty: 'Fácil',
                                      recipe_type: recipe_type, cuisine: 'Nordestina',
                                      cook_time: 60,
                                      ingredients: 'Farinha, açucar, cenoura', user: user,
                                      cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                                      status: :approved)
      get api_v1_recipes_path(status: :approved, cuisine: 'Árabe')

      json_recipes = JSON.parse(response.body, symbolize_names: true)
      # expect(request.status).to eq 200
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'application/json'
      expect(json_recipes[0][:title]).not_to eq pending_recipe.title
      expect(response.body).not_to include other_approved_recipe.title
      expect(json_recipes[0]).to include(title: approved_recipe.title)
      # expect(response.body).to include('Bolo de cenoura')
    end
  end
end
