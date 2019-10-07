require 'rails_helper'

feature 'Admin register recipe type' do
  scenario 'successfully' do
    # Arrange
    # Act
    visit root_path
    click_on 'Enviar tipo da receita'
    fill_in 'Nome', with: 'Sobremesa'
    click_on 'Enviar'
    # Assert
    expect(page).to have_content('Sobremesa')
  end

  scenario 'and not insert duplicated' do
    recipe_type = RecipeType.create(name: "Sobremesa")
    user = User.create!(email: "teste@teste.com", password: "teste123")
    
    login_as(user, :scope => :user)
    visit root_path
    click_on 'Enviar tipo da receita'
    fill_in 'Nome', with: 'Sobremesa'
    click_on 'Enviar'

    expect(page).to have_content('Tipo de receita já cadastrada')
    expect(current_path).not_to have_content('Sobremesa')
  end
end