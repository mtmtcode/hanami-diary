# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
resources :entries, only: [:index, :create, :show, :update, :delete]
resources :templates, only: [:create]
