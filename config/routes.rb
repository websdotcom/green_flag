GreenFlag::Engine.routes.draw do

  namespace :admin do
    resources :features do
      get 'current_visitor_status', on: :member
      resources :white_list_users
      resource :rule_list
      resource :feature_decision_summary
    end
  end

end
