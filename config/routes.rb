# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  constraints(lambda { |req| req.format == :json }) do
    resources :tasks, except: %i[new edit], param: :slug
    resources :users, only: :index
    resources :users, only: %i[index create]
  end

  root "home#index"
  get "*path", to: "home#index", via: :all
end
