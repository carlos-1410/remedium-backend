Rails.application.routes.draw do
  namespace :api do
    devise_for :users, path: "", path_names: { sign_in: "login", sign_out: "logout" }

    namespace :v1 do
      resources :posts
    end
  end
end
