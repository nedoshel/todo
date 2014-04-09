TodoSync::Application.routes.draw do

  resources :tasks, only: [:index]

  constraints ->(r){r.xhr?} do
    resources :tasks, except: [:index]
  end

  root 'home#index'

end
