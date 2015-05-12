Rails.application.routes.draw do

 root :to => 'pages#front'
  
 get 'ui(/:action)', controller: 'ui'

 get '/ruby-version' => 'application#ruby_version'

 resources :funds, except: [:destroy]
 resources :patrons, except: [:destroy]
 
 resources :recharges, except: [:destroy] do
   collection do
     get 'search', to: 'recharges#search'
   end 
   collection do
     get 'process_batch', to: 'recharges#process_batch'
   end 
   collection do
     get 'create_output', to: 'recharges#create_output'
   end
   collection do
     get 'ftp_file', to: 'recharges#ftp_file'
   end
 end

 resources :invoices, except: [:destroy] do
   collection do
     get 'search', to: 'invoices#search'
   end 
   collection do
     get 'process_batch', to: 'invoices#process_batch'
   end 
   collection do
     get 'create_charge_output', to: 'invoices#create_charge_output'
     get 'create_person_output', to: 'invoices#create_person_output'
   end
   collection do
     get 'ftp_file', to: 'invoices#ftp_file'
   end
 end

 get "/signin", to: 'sessions#new', as: :signin
 get "/auth/shibboleth", as: :shibboleth
 get "/auth/developer", to: 'sessions#developer', as: :developer
 match "/auth/shibboleth/callback" => "sessions#shibboleth", as: :callback, via: [:get, :post]
 match "/signout" => "sessions#destroy", as: :signout, via: [:get, :post]
end
