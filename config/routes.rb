Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#ju-overview"
  get "/duan-overview",:to => "welcome#duan-overview"
  get "/station-overview",:to => "welcome#station-overview"

  resources :t_duan_infoes
  resources :t_station_infoes
  namespace :charts do
    get "names"
  end
end
