Rails.application.routes.draw do
  resources :loans do
    resources :payments, only: [:index, :show, :create]
  end
end
