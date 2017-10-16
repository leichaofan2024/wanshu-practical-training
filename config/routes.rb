Rails.application.routes.draw do
    devise_for :users, controllers: { registrations: 'users/registrations' , sessions: 'users/sessions'}
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

      root :to => 'welcome#ju_overview'

    get '/ju_overview', to: 'welcome#ju_overview'
    get '/duan_overview', to: 'welcome#duan_overview'
    get '/station_overview', to: 'welcome#station_overview'
    get '/duan_ck', to: 'welcome#duan_ck'
    get '/station_ck', to: 'welcome#station_ck'
    get '/team_ck', to: 'welcome#team_ck'
    get '/student_ck', to: 'welcome#student_ck'
    get '/program_ck', to: 'welcome#program_ck'
    resources :users
    resources :t_duan_infoes do
        collection do
            get :duan_student_info # 参考学生饼图
            get :duan_score_info               # 得分概览饼图
            get :duan_program_info             # 热点考点饼图
            get :duan_program_student_info     # 做过这道题的学生
            get :duan_reason_info              # 易错题饼图
            get :duan_reason_student_info      # 犯这种错误的学生
        end
    end

    resources :t_station_infoes do
        collection do
            get :station_student_info
            get :station_score_info
        end
    end

    resources :t_team_infoes do
        collection do
            get :team_student_info
            get :team_score_info
        end
    end

    resources :t_user_infoes

  resources :t_record_infoes do
    collection do
      get :student_records
    end
  end
  resources :t_record_detail_infoes do

    collection do
      get :record_details
    end
  end

  resources :call_boards

    namespace :charts do
        get 'names'
    end
end
