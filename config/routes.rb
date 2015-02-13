Rails.application.routes.draw do
 get 'ui(/:action)', controller: 'ui'

 get '/ruby-version' => 'application#ruby_version'
end
