require 'rails_helper'

feature 'user add recipe to recipe list' do
    scenario 'successfully' do
        recipe_type = RecipeType.create(name: "Sobremesa")
        user = User.create!(email: "teste@teste.com", password: "teste123")
        RecipeList.create(name: 'Receitas da Vó', user: user )
        Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
            recipe_type: recipe_type, cuisine: 'Brasileira',
            cook_time: 50,
            ingredients: 'Farinha, açucar, cenoura', user: user,
            cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

        login_as(user, :scope => :user)

        visit root_path
        click_on 'Minhas Receitas'
        click_on 'Bolo de Cenoura'

        select 'Receitas da Vó', from: 'Lista'
        click_on 'Adicionar a lista'
        
        expect(page).to have_css('h1', text: 'Receitas da Vó')
        expect(page).to have_css('li', text: 'Bolo de Cenoura')
    end

    scenario 'and cannot add the same recipe twice' do
        recipe_type = RecipeType.create(name: "Sobremesa")
        user = User.create!(email: "teste@teste.com", password: "teste123")
        recipe_list = RecipeList.create(name: 'Receitas da Vó', user: user )
        recipe = Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
            recipe_type: recipe_type, cuisine: 'Brasileira',
            cook_time: 50,
            ingredients: 'Farinha, açucar, cenoura', user: user,
            cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
        
        recipe_list_item = RecipeListItem.create!(recipe: recipe, recipe_list: recipe_list)
        login_as(user, :scope => :user)

        visit root_path
        click_on 'Minhas Receitas'
        click_on 'Bolo de Cenoura'
        select 'Receitas da Vó', from: 'Lista'
        click_on 'Adicionar a lista'

        expect(page).to have_content('Receita já adicionada a esta lista!')
        expect(current_path).to eq recipe_path(recipe)
    end
end