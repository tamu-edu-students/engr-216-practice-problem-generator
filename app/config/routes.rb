Rails.application.routes.draw do
  root "welcome#index"
  get "welcome/index", to: "welcome#index", as: "welcome"
  get "sessions/logout"
  get "sessions/omniauth"
  get "student_home/index", to: "student_home#index", as: "student_home"
  get "instructor_home/index", to: "instructor_home#index", as: "instructor_home"

  get "instructor_home/custom_template", to: "instructor_home#custom_template", as: "custom_template"
  post "instructor_home/custom_template", to: "instructor_home#create_template", as: "create_custom_template"
  get "instructor_home/summary", to: "instructor_home#summary", as: "instructor_home_summary"

  get "/custom_template",         to: "instructor_home#template_selector",  as: "new_template_selector"
  post "/custom_template/select", to: "instructor_home#select_template_type", as: "select_template_type"

  # Equation-based templates
  get  "/custom_template/equation",  to: "templates#new_equation",  as: "custom_template_equation"
  post "/custom_template/equation",  to: "templates#create_equation"

  # Dataset-based templates
  get  "/custom_template/dataset",   to: "templates#new_dataset",   as: "custom_template_dataset"
  post "/custom_template/dataset",   to: "templates#create_dataset"

  # Definition-based templates
  get  "/custom_template/definition", to: "templates#new_definition", as: "custom_template_definition"
  post "/custom_template/definition", to: "templates#create_definition"

  get "admin/index", to: "admin#index", as: "admin"
  get "admin_roles", to: "admin_roles#index", as: "admin_roles"
  patch "admin_roles/:id/update_role", to: "admin_roles#update_role", as: "update_user_role"

  get "/logout", to: "sessions#logout", as: "logout"
  get "/auth/google_oauth2/callback", to: "sessions#omniauth"
  get "/auth/failure", to: "sessions#failure"

  get "/users/:id", to: "users#show", as: "user"
  get "/users/:id/progress", to: "users#progress", as: "user_progress"
  post "save_instructor", to: "users#save_instructor", as: "save_instructor"

  get "leaderboard", to: "leaderboard#leaderboard", as: "leaderboard"

  # Unified Practice Routes (Problems + Practice Tests)
  get  "/practice",              to: "practice#form",           as: "practice_form"
  post "/practice/create",       to: "practice#create",         as: "practice_create"
  get  "/practice/generation",   to: "practice#generation",     as: "generation"
  post "/practice/submit",       to: "practice#submit_answer",  as: "submit_answer"
  post "/practice/submit_test",  to: "practice#submit_test",    as: "submit_test"
  get  "/practice/result",       to: "practice#result",         as: "practice_result"
  get  "/practice/try_another",  to: "practice#try_another",    as: "try_another_problem"
  post "practice/try_another", to: "practice#try_another", as: "try_another"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA (Optional)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
