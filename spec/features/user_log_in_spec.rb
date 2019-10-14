require 'rails_helper'

feature 'User registration' do
  scenario 'cannot create logout' do
    visit root_path

    expect(page).to have_link('Entrar')
    expect(page).not_to have_link('Sair')
    expect(page).not_to have_link('Enviar Uma Receita')
  end

  scenario 'successfully' do
    visit root_path
    click_on 'Entrar'
    click_on 'Sign up'

    fill_in 'Email', with: 'teste@teste.com'
    fill_in 'Password', with: 'teste123'
    fill_in 'Password confirmation', with: 'teste123'
    click_on 'Sign up'

    expect(page).to have_link('Sair')
    expect(page).not_to have_link('Entrar')
  end

  scenario 'and sign in' do
    User.create!(email: "teste@teste.com", password: "teste123")

    visit root_path
    click_on 'Entrar'

    fill_in 'Email', with: 'teste@teste.com'
    fill_in 'Password', with: 'teste123'
    click_on 'Log in'

    expect(page).not_to have_link('Entrar')
    expect(page).to have_link('Sair')
  end

  scenario 'and sign out' do
    User.create!(email: "teste@teste.com", password: "teste123")

    visit root_path
    click_on 'Entrar'

    fill_in 'Email', with: 'teste@teste.com'
    fill_in 'Password', with: 'teste123'
    click_on 'Log in'
    click_on 'Sair'

    expect(page).to have_link('Entrar')
    expect(page).not_to have_link('Sair')

  end
end