Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#ju-overview"
  get "/duan-overview",:to => "welcome#duan-overview"
  get "/station-overview",:to => "welcome#station-overview"
  get "/duan_ck", :to => "welcome#duan_ck"
  get "/station_ck", :to => "welcome#station_ck"
  get "/team_ck", :to => "welcome#team_ck"
  get "/student_ck", :to => "welcome#student_ck"
  get "/program_ck", :to => "welcome#program_ck"

  resources :t_duan_infoes
  resources :t_station_infoes

  namespace :charts do
    get "names"
  end
end
