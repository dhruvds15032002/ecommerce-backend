Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: [] do
    resources :orders, only: [:index, :show, :create] do
      member do
        put :update_status
      end
    end
  end

  resources :products
  resources :users, only: [:show] do
    collection do
      post :signup
      post :login
      delete :logout
    end
  end

  resources :carts, only: [] do
    collection do
      post 'add_to_cart'
      get 'cart'
      patch 'update_product_quantity'
      delete 'remove_product_from_cart'
    end
  end
end
