Rails.application.routes.draw do

  resources :products, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
    resources :tags, only: [:create, :destroy]
  end

  resources :tags, only: [:index, :edit, :create, :destroy, :update]

  get '/new_tags/:product_id', to: 'cropper#new_tags', as: 'new_tags'
  get 'home', to: 'static#home', as: 'home'
  get '/transcribed_tags', to: 'tags#transcribed_tags', as: 'transcribed_tags'

  # get '/tags_index', to: 'products#tags_index', as: 'tags_index'
  # get '/edit_tag/:id/:tag_id', to: 'products#edit_tag', as: 'edit_tag'
  # post '/tags/', to: 'tags#transcription', as: 'transcription'

  root to: 'static#home'

end