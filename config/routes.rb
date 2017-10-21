Rails.application.routes.draw do

  post '/messages/hospitality-and-concierge',
    to: 'messages#hospitality_concierge',
    as: :hospitality_concierge
  resources :messages, only: [:new, :create]

  post '/enquiry-ticket', to: 'enquiries#create', as: :create_enquiry

  get 'static/sport'
  get 'static/terms'
  get 'static/about'

  get '/competitions/:compet/:id', to: 'players#show', as: :competition_player
  resources :categories, only: [:show, :index]
  resources :competitions, only: [:show, :index]
  resources :events, only: [:show, :index]
  resources :players, only: [:show]
  resources :tickets, only: [:show]

  namespace :admin do
    root 'welcome#index'
    resources :categories
    resources :competitions
    resources :events
    resources :players
    resources :tickets
    resources :venues
    scope '/homepage/' do
      resources :home_line_items
      get '/', to: redirect('/admin')
    end
  end

  scope '/admin/homepage/:slides_kind' do
    get '/', to: 'admin/home_slides#index', as: :admin_home_slides
    post '/', to: 'admin/home_slides#create'
    get 'new', to: 'admin/home_slides#new', as: :new_admin_home_slide
    get ':id/edit', to: 'admin/home_slides#edit', as: :edit_admin_home_slide
    get ':id', to: 'admin/home_slides#show', as: :admin_home_slide
    patch ':id', to: 'admin/home_slides#update'
    put ':id', to: 'admin/home_slides#update'
    delete ':id', to: 'admin/home_slides#destroy'
  end

  root 'home#index'
end
