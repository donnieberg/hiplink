HipchatOrganizer::Application.routes.draw do
  root :to => "home#index"
  get '/about' => 'home#about'

  resources :folders
  resources :links
  resources :tags

end
