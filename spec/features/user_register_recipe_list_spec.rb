require 'rails_helper'

feature 'user register new list' do
  scenario 'successfully' do
    user = User.create!(email: "teste@teste.com", password: "teste123")
    login_as(user, :scope => :user)

    visit root_path
    click_on 'Criar lista'
    fill_in 'Nome', with: 'Receitas de Natal'
    click_on 'Enviar'

    expect(page).to have_css('h1', text: 'Receitas de Natal')
    expect(page).to have_css('p', text: "criado por #{user.email}")
  end

  scenario 'and access their own list' do
    user = User.create!(email: 'teste@teste.com', password: '123456')
    other_user = User.create!(email: 'teste1@teste.com', password: '123456')
    RecipeList.create(name: 'Receitas de Natal', user: user )
    RecipeList.create(name: 'Receitas de Carnaval', user: user )
    RecipeList.create(name: 'Receitas de Pascoa', user: other_user )

    login_as(user, :scope => :user)
    visit root_path
    click_on 'Minhas Listas'

    expect(page).to have_css('h1', text: 'Minhas listas')
    expect(page).to have_css('li', text: 'Receitas de Natal')
    expect(page).to have_css('li', text: 'Receitas de Carnaval')
    expect(page).not_to have_css('li', text: 'Receitas de Pascoa')
  end

  scenario 'and cannot create duplicated lists' do
    user = User.create!(email: 'teste@teste.com', password: '123456')    
    RecipeList.create(name: 'Receitas de Natal', user: user )

    login_as(user, :scope => :user)
    visit root_path
    click_on 'Criar lista'
    fill_in 'Nome', with: 'Receitas de Natal'
    click_on 'Enviar'

    expect(current_path).to eq recipe_lists_path
    expect(page).to have_content('Lista já existe!') 
  end
end