Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "home#index"

  get("/about", { to: "home#about", as: :about })

  resources :users, only: [:new, :create, :edit, :update]

  resource :session, only: [:new, :create, :destroy]
  # Notice that `resource` is singular. Unlike `resources`,
  # `resource` will create routes that are meant to do CRUD
  # on a single thing. There will be no index route or any
  # route with :id. When using singular resource, the controller
  # it links to should still be plural.

  resources :projects do

    resources :tasks, shallow: true, only: [:create, :update, :edit]

    resources :discussions, shallow: true, only: [:create, :destroy, :update, :edit] do

      resources :comments, shallow: true, only: [:create, :destroy, :update, :edit]

    end

  end

end
