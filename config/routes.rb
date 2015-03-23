Rails.application.routes.draw do

 root :to => 'pages#front'
  
 get 'ui(/:action)', controller: 'ui'

 get '/ruby-version' => 'application#ruby_version'

 resources :funds, except: [:destroy]
 
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

 post "/auth/:provider/callback" => "sessions#create", :as => :signin
 get "/signout" => "sessions#destroy", :as => :signout
end
