# frozen_string_literal: true

require 'rails_helper'

feature 'admin evaluate pending recipes' do
  scenario 'and approves recipes' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    user = User.create!(email: 'teste@teste.com', password: 'teste123', user_type: :admin)

    pending_recipe = Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
                                   recipe_type: recipe_type, cuisine: 'Brasileira',
                                   cook_time: 50,
                                   ingredients: 'Farinha, açucar, cenoura', user: user,
                                   cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes', status: :pending)
    login_as(user, scope: :user)
    visit root_path

    click_on 'Receitas Pendentes'
    click_on 'Bolo de Cenoura'
    click_on 'Aprovar'

    expect(page).not_to have_link('Aprovar')
    pending_recipe.reload
    expect(pending_recipe).to be_approved
  end

  scenario 'and reproves recipes' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    user = User.create!(email: 'teste@teste.com', password: 'teste123', user_type: :admin)

    pending_recipe = Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
                                   recipe_type: recipe_type, cuisine: 'Brasileira',
                                   cook_time: 50,
                                   ingredients: 'Farinha, açucar, cenoura', user: user,
                                   cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes', status: :pending)
    login_as(user, scope: :user)
    visit root_path

    click_on 'Receitas Pendentes'
    click_on 'Bolo de Cenoura'
    click_on 'Reprovar'

    expect(page).not_to have_link('Aprovar')
    expect(page).not_to have_link('Reprovar')
    pending_recipe.reload
    expect(pending_recipe).to be_reproved
  end

  scenario 'and only admin approves/reproves pending recipes' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    user = User.create!(email: 'teste@teste.com', password: 'teste123', user_type: :customer)

    pending_recipe = Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
                                   recipe_type: recipe_type, cuisine: 'Brasileira',
                                   cook_time: 50,
                                   ingredients: 'Farinha, açucar, cenoura', user: user,
                                   cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes', status: :pending)

    login_as(user, scope: :user)
    visit root_path

    expect(page).not_to have_link('Receitas Pendentes')
    pending_recipe.reload
    expect(pending_recipe).to be_pending
  end
end
