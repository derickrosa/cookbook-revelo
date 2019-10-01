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
end