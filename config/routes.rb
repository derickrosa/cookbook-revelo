Rails.application.routes.draw do
  devise_for :users
  root to: 'recipes#index'

  resources :recipes, only: [:index, :show, :new, :create, :edit, :update] do
    collection do
      get 'search'
      get 'pending'
      get 'approve_list'
      # get 'lists/my_lists', to: 'recipe_lists#my_recipe_lists'
      get '/my_recipes', to: 'recipes#my_recipes'
      # resources :recipe_lists, only: [:new, :create, :show, :edit, :update]
      resources 'lists', controller: :recipe_lists, only: %i[new create show edit update] do
        get 'my_lists', on: :collection
      end

      # resolve('Lists') { [:recipe_lists] }
    end

    member do
      post 'add_to_list'
      post 'approve'
      post 'reprove'
    end
  end

  namespace 'api' do
    namespace 'v1' do
      resources :recipes, only: %i[index]
    end
  end

  get '/my_recipes', to: 'recipes#my_recipes'
  get 'recipe_lists/my_recipe_lists', to: 'recipe_lists#my_recipe_lists'
  
  resources :recipe_types, only: %i[new create show index]
end
