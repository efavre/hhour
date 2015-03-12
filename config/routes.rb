Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :devices
  resources :users
  resources :challenges do 
    resources :pictures
  end
  resources :pictures do 
    resources :comments
  end

end
