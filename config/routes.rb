Rails.application.routes.draw do
  devise_for :users
  root to: 'recipes#index'
  resources :recipes, only: [:index, :show, :new, :create, :edit, :update]
  resources :recipe_types, only: %i[new create show index]
  get '/search', to: 'recipes#search'
  get '/my_recipes', to: 'recipes#my_recipes'

  resources :recipe_lists, only: [:new, :create, :show, :edit, :update]
end
