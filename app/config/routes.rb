Rails.application.routes.draw do
  root "welcome#index"
  get "welcome/index", to: "welcome#index", as: "welcome"
  get "sessions/logout"
  get "sessions/omniauth"
  get "student_home/index", to: "student_home#index", as: "student_home"
  get "instructor_home/index", to: "instructor_home#index", as: "instructor_home"

  get "instructor_home/custom_template", to: "instructor_home#custom_template", as: "custom_template"
  # post "instructor_home/create_template", to: "instructor_home#create_template", as: "create_custom_template"
  post "instructor_home/custom_template", to: "instructor_home#create_template", as: "create_custom_template"
  get 'instructor_home/summary', to: "instructor_home#summary", as: "instructor_home_summary"

  get "admin/index", to: "admin#index", as: "admin"
  get "admin_roles", to: "admin_roles#index", as: "admin_roles"
  patch "admin_roles/:id/update_role", to: "admin_roles#update_role", as: "update_user_role"

  get "/logout", to: "sessions#logout", as: "logout"
  get "/auth/google_oauth2/callback", to: "sessions#omniauth"

  get "/users/:id", to: "users#show", as: "user"
  post "save_instructor", to: "users#save_instructor", as: "save_instructor"

  get "/auth/failure", to: "sessions#failure"

  get "problems/problem_form", to: "problems#problem_form", as: "problem_form"
  get "problems/problem_generation", to: "problems#problem_generation", as: "problem_generation"
  post "problems/problem_form", to: "problems#create"
  post "problems/submit_answer", to: "problems#submit_answer", as: "submit_answer"
  post 'try_another_problem', to: 'problems#try_another_problem', as: 'try_another_problem'

  get "/users/:id/progress", to: "users#progress", as: "user_progress"

  get "practice_tests/practice_test_form", to: "practice_tests#practice_test_form", as: "practice_test_form"
  post "practice_tests/practice_test_form", to: "practice_tests#create"
  get "practice_tests/practice_test_generation", to: "practice_tests#practice_test_generation", as: "practice_test_generation"
  post "practice_tests/submit_practice_test", to: "practice_tests#submit_practice_test", as: "submit_practice_test"
  get "practice_tests/result", to: "practice_tests#result", as: "practice_test_result"

  get "leaderboard", to: "leaderboard#leaderboard", as: "leaderboard"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
