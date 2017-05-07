Rails.application.routes.draw do
  devise_for :employers, :controllers => {:registrations => "employers/registrations", :sessions => "employers/sessions", :passwords => "employers/passwords"}
  devise_for :users, :controllers => {:registrations => "users/registrations", :sessions => "users/sessions", :passwords => "users/passwords"}
  devise_for :admins
  resources :listings
  resources :companies
  resources :admin, controller: "boards"

  match '', to: 'listings#index', via: :get, constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  root to: 'home#index'
end
