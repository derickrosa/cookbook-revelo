# frozen_string_literal: true

require 'rails_helper'

describe 'Admin logged in to approve recipe' do
  it 'access list' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    user = User.create!(email: 'teste@teste.com', password: 'teste123',
                        user_type: :customer)

    Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: 'Brasileira',
                  cook_time: 50,
                  ingredients: 'Farinha, açucar, cenoura', user: user,
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes', status: :pending)

    login_as(user, scope: :user)

    get approve_list_recipes_path
    expect(response).to redirect_to(root_path)
  end

  it 'access approve' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    user = User.create!(email: 'teste@teste.com', password: 'teste123',
                        user_type: :customer)

    pending_recipe = Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
                                   recipe_type: recipe_type, cuisine: 'Brasileira',
                                   cook_time: 50,
                                   ingredients: 'Farinha, açucar, cenoura', user: user,
                                   cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes', status: :pending)

    login_as(user, scope: :user)

    post approve_recipe_path(pending_recipe)
    expect(response).to redirect_to(root_path)
    expect(pending_recipe).to be_pending
  end

  it 'access reprove' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    user = User.create!(email: 'teste@teste.com', password: 'teste123',
                        user_type: :customer)

    pending_recipe = Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
                                   recipe_type: recipe_type, cuisine: 'Brasileira',
                                   cook_time: 50,
                                   ingredients: 'Farinha, açucar, cenoura', user: user,
                                   cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes', status: :pending)

    login_as(user, scope: :user)

    post reprove_recipe_path(pending_recipe)
    expect(response).to redirect_to(root_path)
    expect(pending_recipe).to be_pending
  end
end
