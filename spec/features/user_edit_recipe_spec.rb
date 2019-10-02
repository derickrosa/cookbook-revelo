require 'rails_helper'

feature 'User update recipe' do
  scenario 'successfully' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    user = User.create!(email: "teste@teste.com", password: "teste123")
    RecipeType.create(name: 'Entrada')
    Recipe.create!(title: 'Bolodecenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: 'Brasileira',
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura', user: user,
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    # simula a ação do usuário
    visit root_path
    login_as(user, :scope => :user)
    click_on 'Bolodecenoura'
    click_on 'Editar'

    fill_in 'Título', with: 'Bolo de cenoura'
    select 'Entrada', from: 'Tipo da Receita'
    fill_in 'Dificuldade', with: 'Médio'
    fill_in 'Tempo de Preparo', with: '45'
    fill_in 'Ingredientes', with: 'Cenoura, farinha, ovo, oleo de soja e chocolate'
    fill_in 'Como Preparar', with: 'Faça um bolo e uma cobertura de chocolate'

    click_on 'Enviar'

    expect(page).to have_css('h1', text: 'Bolo de cenoura')
    expect(page).to have_css('h3', text: 'Detalhes')
    expect(page).to have_css('p', text: 'Médio')
    expect(page).to have_css('p', text: '45 minutos')
    expect(page).to have_css('p', text:  'Cenoura, farinha, ovo, oleo de soja e chocolate')
    expect(page).to have_css('p', text: 'Faça um bolo e uma cobertura de chocolate')
  end

  scenario 'and must fill in all fields' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    user = User.create!(email: "teste@teste.com", password: "teste123")
    Recipe.create(title: 'Bolodecenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: 'Brasileira',
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura', user: user,
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    # simula a ação do usuário
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Bolodecenoura'
    click_on 'Editar'

    fill_in 'Título', with: ''
    fill_in 'Cozinha', with: ''
    fill_in 'Dificuldade', with: ''
    fill_in 'Tempo de Preparo', with: ''
    fill_in 'Ingredientes', with: ''
    fill_in 'Como Preparar', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Não foi possível salvar a receita')
  end

  scenario 'and needs to own the recipe' do
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

    click_on 'Pudim'

    expect(page).not_to have_link('Editar')
  end


  scenario 'and is not signed in' do
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

    click_on 'Bolo de cenoura'

    expect(page).not_to have_link('Editar')
  end

  scenario 'and is not signed in' do
    recipe_type = RecipeType.create(name: "Sobremesa")
    user = User.create!(email: "teste@teste.com", password: "teste123")

    Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: 'Brasileira',
                  cook_time: 50,
                  ingredients: 'Farinha, açucar, cenoura', user: user,
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
    recipe = Recipe.create(title: 'Bolo de chocolate', difficulty: 'Fácil',
                  recipe_type: recipe_type, cuisine: 'Árabe',
                  cook_time: 60,
                  ingredients: 'Farinha, açucar, cenoura', user: user,
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    visit edit_recipe_path(recipe)

    expect(current_path).to eq new_user_session_path
  end

  scenario 'and user logged in not edit other recipes' do
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
    recipe = Recipe.create(title: 'Pudim', difficulty: 'Fácil',
                  recipe_type: recipe_type, cuisine: 'Alemã',
                  cook_time: 60,
                  ingredients: 'Farinha, açucar, cenoura', user: other_user,
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    login_as(user, :scope => :user)
    visit edit_recipe_path(recipe)

    expect(current_path).to eq root_path
  end

end
