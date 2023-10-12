Rails.application.routes.draw do
  resources :weathers, only: %i[new index]
  root 'weathers#index'
end
