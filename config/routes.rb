Rails.application.routes.draw do

  resources :imagebinders, :only => [:create, :update], :controller => "imagebinder/imagebinders" do
    member do
      get :crop
    end
  end  


end
