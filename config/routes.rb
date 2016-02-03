Rails.application.routes.draw do
  resources :players
  resources :incompatibles
  resources :drafts
  resources :bands
  resources :mates
  get "incompatible_player" => 'home#incompatiblePlayer'
  get "compatible_player" => 'home#compatiblePlayer'
  get "live_player_picture" => 'home#livePlayerPicture'
  get 'livedraft' => 'home#comptest'
  get "home/compatible"
  get "trade" => "home#commit_trade"
  get "livebands" => 'home#bands'
  get "updatedBand" => 'home#updatedBand'
  get "liveplayer" => 'home#livePlayer'
  get "mj" => "home#mjView"
  get "add_player_to_band" => "home#add_player_to_band"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
end
