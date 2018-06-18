Rails.application.routes.draw do
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/tweets' => 'tweet#index'
  get '/tweet/new' => 'tweet#new'
  post '/tweet/create' => 'tweet#create'
  get '/tweet/:id/destroy' => 'tweet#destroy'
  get '/tweet/:id/edit' => 'tweet#edit'
  post '/tweet/:id/update' => 'tweet#update'
  get '/tweet/:id' => 'tweet#show'
end
