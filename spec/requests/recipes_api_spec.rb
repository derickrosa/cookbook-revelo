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

  context 'show' do
    it 'and view recipe details' do
      recipe_type = RecipeType.create(name: 'Sobremesa')
      user = User.create!(email: 'teste_show@teste.com', password: 'teste123')
      recipe = Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                             recipe_type: recipe_type, cuisine: 'Brasileira',
                             cook_time: 50,
                             ingredients: 'Farinha, açucar, cenoura', user: user,
                             cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                             status: :pending)

      get api_v1_recipe_path(recipe)

      json_recipes = JSON.parse(response.body, symbolize_names: true)
      # expect(request.status).to eq 200
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'application/json'
      expect(json_recipes[:title]).to eq recipe.title
      expect(json_recipes[:cuisine]).to eq recipe.cuisine
      expect(json_recipes[:recipe_type][:name]).to eq recipe.recipe_type.name
      expect(json_recipes[:cook_method]).to eq recipe.cook_method
      expect(json_recipes[:cook_time]).to eq recipe.cook_time
      expect(json_recipes[:ingredients]).to eq recipe.ingredients
      expect(json_recipes[:difficulty]).to eq recipe.difficulty
      expect(json_recipes[:status]).to eq recipe.status
      # expect(response.body).to include('Bolo de cenoura')
    end

    it 'not found' do
      get api_v1_recipe_path(100)

      JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to eq 'application/json'
      expect(response.body).to include('Receita não encontrada!')
    end
  end

  context 'register' do
    it 'successfully' do
      recipe_type = RecipeType.create(name: 'Sobremesa')
      user = User.create!(email: 'teste_show@teste.com', password: 'teste123')

      post api_v1_recipes_path, params: { "title": 'Bolo de cenoura',
                                         "difficulty": 'Médio',
                                         "cook_time": 50,
                                         "cuisine": 'Brasileira',
                                         "cook_method": 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                                         "ingredients": 'Farinha, açucar, cenoura',
                                         "status": 'approved',
                                         "recipe_type_id": recipe_type.id,
                                         "user_id": user.id }
                                         
      json_recipes = JSON.parse(response.body, symbolize_names: true)
      # expect(request.status).to eq 200
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'application/json'
      expect(json_recipes[:title]).to eq 'Bolo de cenoura'
      expect(json_recipes[:cuisine]).to eq 'Brasileira'
      expect(json_recipes[:recipe_type][:id]).to eq recipe_type.id
      expect(json_recipes[:user][:id]).to eq user.id
      expect(json_recipes[:cook_method]).to eq 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes'
      expect(json_recipes[:cook_time]).to eq 50
      expect(json_recipes[:ingredients]).to eq 'Farinha, açucar, cenoura'
      expect(json_recipes[:difficulty]).to eq 'Médio'
      expect(json_recipes[:status]).to eq 'approved'
    end

    scenario 'failed' do
      post api_v1_recipes_path, params: { title: '',
                                         difficulty: '',
                                         cook_time: '',
                                         cuisine: '',
                                         cook_method: '',
                                         ingredients: '',
                                         status: '',
                                         recipe_type_id: '',
                                         user_id: '' }
      json_recipes = JSON.parse(response.body, symbolize_names: true)
      # expect(request.status).to eq 200
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq 'application/json'
      expect(json_recipes[:error]).to eq 'Todos os campos são obrigatórios'
    end
  end

  context 'update' do
    it 'successfully' do
      recipe_type = RecipeType.create(name: 'Sobremesa')
      other_recipe_type = RecipeType.create(name: 'Entrada')
      user = User.create!(email: 'teste_show@teste.com', password: 'teste123')
      recipe = Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                             recipe_type: recipe_type, cuisine: 'Brasileira',
                             cook_time: 50,
                             ingredients: 'Farinha, açucar, cenoura', user: user,
                             cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                             status: :pending)

      put api_v1_recipe_path(recipe), params: { "recipe": { "title": 'Bolo de cenoura',
                                                            "difficulty": 'Alta',
                                                            "cook_time": 100,
                                                            "cuisine": 'Peruana',
                                                            "cook_method": 'Frite a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                                                            "ingredients": 'Farinha, açucar, cenoura, limão',
                                                            "status": 'pending',
                                                            "recipe_type_id": other_recipe_type.id,
                                                            "user_id": user.id } }

      json_recipes = JSON.parse(response.body, symbolize_names: true)
      # expect(request.status).to eq 200
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'application/json'
      expect(json_recipes[:title]).to eq 'Bolo de cenoura'
      expect(json_recipes[:cuisine]).to eq 'Peruana'
      expect(json_recipes[:recipe_type][:id]).to eq other_recipe_type.id
      expect(json_recipes[:user][:id]).to eq user.id
      expect(json_recipes[:cook_method]).to eq 'Frite a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes'
      expect(json_recipes[:cook_time]).to eq 100
      expect(json_recipes[:ingredients]).to eq 'Farinha, açucar, cenoura, limão'
      expect(json_recipes[:difficulty]).to eq 'Alta'
      expect(json_recipes[:status]).to eq 'pending'
    end
  end

  xcontext 'delete' do
    it 'successfully' do
      recipe_type = RecipeType.create(name: 'Sobremesa')
      user = User.create!(email: 'teste_show@teste.com', password: 'teste123')
      recipe = Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                             recipe_type: recipe_type, cuisine: 'Brasileira',
                             cook_time: 50,
                             ingredients: 'Farinha, açucar, cenoura', user: user,
                             cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                             status: :pending)

      get api_v1_recipe_path(recipe)

    end
  end
end
