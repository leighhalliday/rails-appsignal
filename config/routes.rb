Rails.application.routes.draw do
  root 'companies#index'

  resources :companies, only: %i[index] do
    member { post :register }
  end
  get '/:exchange/:symbol', to: 'companies#show', as: :company
end
