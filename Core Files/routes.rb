Rails.application.routes.draw do
  root 'parser#home'
  get 'home', to: 'parser#home'
  
  post 'uploads', to: 'parser#create' #feeding file input data to create action
  get 'uploads', to: 'parser#create' #if you refresh, brought back to home page




  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
