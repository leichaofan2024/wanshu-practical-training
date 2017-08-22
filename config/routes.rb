Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "t_duan_infoes#index"
  resources :t_station_infoes
end
