Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tradings
  get 'trade_list', to: 'tradings#trade_list'

  root 'tradings#trade_list'
end
