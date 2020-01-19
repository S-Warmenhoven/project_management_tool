Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "home#index"

  get("/about", { to: "home#about", as: :about })

  resources :projects do

    resources :tasks, shallow: true, only: [:create, :update, :edit]

    resources :discussions, shallow: true, only: [:create, :destroy, :update, :edit] do

      resources :comments, shallow: true, only: [:create, :destroy, :update, :edit]
      
    end

  end

end
