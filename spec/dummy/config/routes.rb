Rails.application.routes.draw do

  resources :feature_checks

  mount GreenFlag::Engine => "/green_flag"
end
