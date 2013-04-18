Rails.application.routes.draw do

  resources :imagebinders, :only => [:create, :update] do
    member do
      get :crop
    end
  end  


end
