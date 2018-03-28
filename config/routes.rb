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
    get '/duan_users', to: 'users#duan_users'
    get '/ju_users', to: 'users#ju_users'
    get '/new_duan', to: 'users#new_duan'
    get '/new_station', to: 'users#new_station'
    get '/new_duan_station', to: 'users#new_duan_station'
    get '/duan_call_boards', to: 'call_boards#duan_call_boards'
    get '/update_note',to: 'welcome#update_note'
    get "/baogao", to: "welcome#baogao"
    post "/create_kuaizhao", to: "t_baogao_infos#create_kuaizhao"
    resources :t_chejian_counts
    resources :users
    resources :browses
    resources :employees do
      collection do
        get :employe_record
        get :duan_record
      end
    end
    resources :t_program_infoes do
      member do
        get :program_duan_ck
        get :program_station_ck
        get :program_team_ck
        get :program_student_ck

        get :program_duan_student_info
        get :program_station_student_info
        get :program_team_student_info
        get :program_student_records
        get :program_record_details

        get :program_duan_dabiao_info
        get :program_station_dabiao_info
        get :program_team_dabiao_info
        get :program_dabiao_records
        get :program_dabiao_details

        get :program_duan_score_info
        get :program_station_score_info
        get :program_team_score_info
        get :program_score_records
        get :program_record_score_details

        get :program_reason_info
        get :program_reason_student_info
      end
    end

    resources :t_duan_infoes do
        collection do
            get :duan_student_info # 参考学生饼图
            get :duan_dabiao_info  # 达标考生
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
            get :station_dabiao_info
            get :station_score_info

        end

    end

    resources :t_team_infoes do
        collection do
            get :team_student_info
            get :team_dabiao_info
            get :team_score_info
        end
    end

    resources :t_user_infoes do
      member do
        patch :set_student_status
        post :set_vacation_status

      end
    end

  resources :t_record_infoes do
    collection do
      get :student_records
      get :dabiao_records
      get :score_records
      patch :time_length
    end

  end
  resources :t_record_detail_infoes do

    collection do
      get :record_details
      get :dabiao_details
      get :record_score_details
    end
  end

  resources :call_boards

    namespace :charts do
        get 'names'
    end


end
