require 'rails_helper'

describe 'user add recipe to recipe_list' do
    it 'and does not own the recipe list' do
        recipe_type = RecipeType.create(name: "Sobremesa")
        user = User.create!(email: "teste@teste.com", password: "teste123")
        other_user = User.create!(email: "teste1@teste.com", password: "teste123")
        recipe_list = RecipeList.create(name: 'Receitas da Vó', user: other_user )
        recipe = Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
            recipe_type: recipe_type, cuisine: 'Brasileira',
            cook_time: 50,
            ingredients: 'Farinha, açucar, cenoura', user: user,
            cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
        recipe_list_item = RecipeListItem.create!(recipe: recipe, recipe_list: recipe_list)
        login_as(user, :scope => :user)

        post "/recipes/#{recipe.id}/add_to_list", :params => {recipe_list: recipe_list.id}

        expect(response).to redirect_to(root_path)
    end    

    it 'and is not signed in' do
        recipe_type = RecipeType.create(name: "Sobremesa")
        user = User.create!(email: "teste@teste.com", password: "teste123")
        other_user = User.create!(email: "teste1@teste.com", password: "teste123")
        recipe_list = RecipeList.create(name: 'Receitas da Vó', user: other_user )
        recipe = Recipe.create(title: 'Bolo de Cenoura', difficulty: 'Médio',
            recipe_type: recipe_type, cuisine: 'Brasileira',
            cook_time: 50,
            ingredients: 'Farinha, açucar, cenoura', user: user,
            cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
        recipe_list_item = RecipeListItem.create!(recipe: recipe, recipe_list: recipe_list)
     

        post "/recipes/#{recipe.id}/add_to_list", :params => {recipe_list: recipe_list.id}

        expect(response).to redirect_to(root_path)
    end    
end