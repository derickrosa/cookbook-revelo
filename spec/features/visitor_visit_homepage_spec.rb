require 'rails_helper'

feature 'Visitor visit homepage' do
  scenario 'successfully' do
    visit root_path

    expect(page).to have_css('h1', text: 'CookBook')
    expect(page).to have_css('p', text: 'Bem-vindo ao maior livro de receitas online')
  end

  scenario 'and view only approved recipes' do
    #cria os dados necessários
    recipe_type = RecipeType.create(name: 'Sobremesa')
    another_recipe_type = RecipeType.create(name: 'Prato principal')
    user = User.create!(email: "teste@teste.com", password: "teste123")
    pending_recipe = Recipe.create(title: 'Bolo de cenoura', difficulty: 'Médio',
                           recipe_type: recipe_type, cuisine: 'Brasileira',
                           cook_time: 50,
                           ingredients: 'Farinha, açucar, cenoura', user: user,
                           cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes',
                           status: :pending)

    approved_recipe = Recipe.create(title: 'Feijoada',
                                   recipe_type: another_recipe_type,
                                   cuisine: 'Japonesa', difficulty: 'Difícil',
                                   cook_time: 90,
                                   ingredients: 'Feijão e carnes',  user: user,
                                   cook_method: 'Misture o feijão com as carnes',
                                   status: :approved)

    # simula a ação do usuário
    visit root_path

    # expectativas do usuário após a ação
    expect(page).not_to have_css('h1', text: pending_recipe.title)
    expect(page).not_to have_css('li', text: pending_recipe.recipe_type.name)
    expect(page).not_to have_css('li', text: pending_recipe.cuisine)
    expect(page).not_to have_css('li', text: pending_recipe.difficulty)
    expect(page).not_to have_css('li', text: "#{pending_recipe.cook_time} minutos")

    expect(page).to have_css('h1', text: approved_recipe.title)
    expect(page).to have_css('li', text: approved_recipe.recipe_type.name)
    expect(page).to have_css('li', text: approved_recipe.cuisine)
    expect(page).to have_css('li', text: approved_recipe.difficulty)
    expect(page).to have_css('li', text: "#{approved_recipe.cook_time} minutos")
  end
end
