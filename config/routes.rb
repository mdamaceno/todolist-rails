Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  resources :tasks do
    collection do
      resources :reports, only: :index, controller: 'task_reports'
    end
    resources :comments, only: %i[create destroy], controller: 'task_comments'
  end

  resources :profiles, only: %i[show new create update edit] do
    get 'private_page', on: :member
    post 'change_privacy', on: :member
    resources :comments, only: %i[index]
  end

  resources :pluses, only: %i[create destroy]
  resources :minuses, only: %i[create destroy]
end
