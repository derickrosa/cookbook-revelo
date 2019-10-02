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
end