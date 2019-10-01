require 'rails_helper'

feature 'Visitor view recipes filtered by recipe type' do
  scenario 'sucessfully' do
    recipe_type = RecipeType.create(name: "Sobremesa")
    other_recipe_type = RecipeType.create(name: "Entrada")

    Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: 'Brasileira',
                  cook_time: 50,
                  ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
    Recipe.create(title: 'Bolo de chocolate', difficulty: 'Fácil',
                  recipe_type: recipe_type, cuisine: 'Árabe',
                  cook_time: 60,
                  ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
    Recipe.create(title: 'Pudim', difficulty: 'Fácil',
                  recipe_type: other_recipe_type, cuisine: 'Alemã',
                  cook_time: 60,
                  ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    visit root_path

    click_on 'Ver tipos de receitas'
    click_on "Sobremesa"


    expect(page).to have_css('h1', text: 'Sobremesa')
    expect(page).to have_css('li', text: 'Bolo de cenoura')
    expect(page).to have_css('li', text: 'Bolo de chocolate')
  end
  scenario 'and there there no recipes with the specified type' do
    recipe_type = RecipeType.create(name: "Sobremesa")
    other_recipe_type = RecipeType.create(name: "Entrada")

    Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: 'Brasileira',
                  cook_time: 50,
                  ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
    Recipe.create(title: 'Bolo de chocolate', difficulty: 'Fácil',
                  recipe_type: recipe_type, cuisine: 'Árabe',
                  cook_time: 60,
                  ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
    Recipe.create(title: 'Pudim', difficulty: 'Fácil',
                  recipe_type: recipe_type, cuisine: 'Alemã',
                  cook_time: 60,
                  ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    visit root_path

    click_on 'Ver tipos de receitas'
    click_on "Entrada"


    expect(page).to have_css('h1', text: 'Entrada')
    expect(page).not_to have_css('li', text: 'Bolo de cenoura')
    expect(page).not_to have_css('li', text: 'Bolo de chocolate')
    expect(page).not_to have_css('li', text: 'Pudim')
  end
end