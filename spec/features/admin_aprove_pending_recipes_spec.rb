require 'rails_helper'

feature 'admin aprove pending recipes' do
    scenario 'successfully' do
        recipe_type = RecipeType.create(name: "Sobremesa")
        user = User.create!(email: "teste@teste.com", password: "teste123")

        pending_recipe = Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
                      recipe_type: recipe_type, cuisine: 'Brasileira',
                      cook_time: 50,
                      ingredients: 'Farinha, açucar, cenoura', user: user,
                      cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes', status: :pending)
        login_as(user, :scope => :user)
        visit root_path

        click_on 'Receitas Pendentes'
        click_on 'Bolo de Cenoura'
        click_on 'Aprovar'

        expect(page).not_to have_link('Aprovar')
        pending_recipe.reload
        expect(pending_recipe).to be_approved
    end
end