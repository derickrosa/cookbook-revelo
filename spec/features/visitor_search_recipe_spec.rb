require 'rails_helper'

feature 'Visitor searchs for a recipe' do
  scenario 'successfully' do
    recipe_type = RecipeType.create(name: "Sobremesa")
    user = User.create!(email: "teste@teste.com", password: "teste123")
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

    visit root_path

    fill_in 'Busca', with: 'Bolo de cenoura'
    click_on 'Buscar'

    expect(page).to have_content('Resultados da Busca')
    expect(page).to have_content('1 resultado encontrado para: Bolo de cenoura')
    expect(page).to have_css('li', text: 'Bolo de cenoura')
    expect(page).not_to have_css('li', text: 'Bolo de chocolate')
  end
  scenario 'and returns no result' do
    recipe_type = RecipeType.create(name: "Sobremesa")
    user = User.create!(email: "teste@teste.com", password: "teste123")
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

    visit root_path

    fill_in 'Busca', with: 'Torta de maçã'
    click_on 'Buscar'

    expect(page).to have_content('Resultados da Busca')
    expect(page).to have_content('Não foram encontrados resultados para: Torta de maçã')
    expect(page).not_to have_css('li', text: 'Bolo de cenoura')
    expect(page).not_to have_css('li', text: 'Bolo de chocolate')
  end

  scenario 'with partial title successfully' do
    recipe_type = RecipeType.create(name: "Sobremesa")
    user = User.create!(email: "teste@teste.com", password: "teste123")
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

    visit root_path

    fill_in 'Busca', with: 'Bolo'
    click_on 'Buscar'

    expect(page).to have_content('Resultados da Busca')
    expect(page).to have_content('2 resultados encontrados para: Bolo')
    expect(page).not_to have_content('1 resultado(s) encontrado(s)')
    expect(page).to have_css('li', text: 'Bolo de cenoura')
    expect(page).to have_css('li', text: 'Bolo de chocolate')
  end

end