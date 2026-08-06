Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "/up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#index"

  get "/accessibility" => "pages#accessibility"
  get "/cookies" => "pages#cookies"
  get "/privacy" => "pages#privacy"
  get "/terms-of-use" => "pages#terms_of_use"

  get "/get-started" => "pages#get_started"

  get "/about" => "pages#about"
  get "/about/features" => "pages#features", as: :features
  get "/about/forthcoming-features" => "pages#forthcoming_features", as: :forthcoming_features
  get "/about/create-good-forms" => "pages#create_good_forms", as: :create_good_forms
  get "/about/processing-completed-form-submissions" => "pages#processing_completed_form_submissions", as: :processing_completed_form_submissions
  get "/about/data-protection-security" => "pages#data_protection_security", as: :data_protection_security

  get "/features" => redirect("/about/features")
  get "/forthcoming-features" => redirect("/about/forthcoming-features")
  get "/create-good-forms" => redirect("/about/create-good-forms")
  get "/processing-completed-form-submissions" => redirect("/about/processing-completed-form-submissions")

  resources :performance, only: %i[index]

  get "/security.txt" => redirect("https://vulnerability-reporting.service.security.gov.uk/.well-known/security.txt")
  get "/.well-known/security.txt" => redirect("https://vulnerability-reporting.service.security.gov.uk/.well-known/security.txt")

  get "/support" => "support#support", as: :support
  post "/support" => "support#new", as: :new_support_message
  get "/support/help-using-forms" => "support#help_using_forms", as: :help_using_forms
  post "/support/help-using-forms" => "support#submit"
  get "/support/question-about-forms" => "support#question_about_forms", as: :question_about_forms
  post "/support/question-about-forms" => "support#submit"

  get "/json-submissions/v1/schema" => "json_submissions#schema_v1", as: :json_submissions_schema_v1

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
