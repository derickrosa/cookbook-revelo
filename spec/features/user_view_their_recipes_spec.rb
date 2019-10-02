require 'rails_helper'

feature 'User only view their own recipes' do
  scenario 'successfully' do
    recipe_type = RecipeType.create(name: "Sobremesa")
    user = User.create!(email: "teste@teste.com", password: "teste123")
    other_user = User.create!(email: "other_teste@teste.com", password: "teste123")

    Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: 'Brasileira',
                  cook_time: 50,
                  ingredients: 'Farinha, açucar, cenoura', user: user,
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
    Recipe.create(title: 'Bolo de chocolate', difficulty: 'Fácil',
                  recipe_type: recipe_type, cuisine: 'Árabe',
                  cook_time: 60,
                  ingredients: 'Farinha, açucar, cenoura', user: user,
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
    Recipe.create(title: 'Pudim', difficulty: 'Fácil',
                  recipe_type: recipe_type, cuisine: 'Alemã',
                  cook_time: 60,
                  ingredients: 'Farinha, açucar, cenoura', user: other_user,
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    login_as(user, :scope => :user)
    visit root_path
    click_on 'Minhas Receitas'

    expect(page).to have_css('h1', text: 'Minhas Receitas')
    expect(page).to have_css('li', text: 'Bolo de cenoura')
    expect(page).to have_css('li', text: 'Bolo de chocolate')
    expect(page).not_to have_css('li', text: 'Pudim')
  end
end