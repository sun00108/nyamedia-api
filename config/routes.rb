Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/api/v1/series', to: 'series#index'
  get '/api/v1/series/latest', to: 'series#fetch_latest_update'
  get '/api/v1/series/:id', to: 'series#info'
  post '/api/v1/series/add', to: 'series#add'
  post '/api/v1/series/:id/edit', to: 'series#edit'
  post '/api/v1/series/:id/delete', to: 'series#delete'

  post '/dev/api/v1/series/sync/tmdb', to: 'series#sync_nfo_tmdb'
  post '/dev/api/v1/series/sync/bgm', to: 'series#sync_nfo_bgm'

  get '/api/v1/videos', to: 'videos#index'
  get '/api/v1/videos/:id', to: 'videos#info'
  get '/api/v1/videos/series/:series_id', to: 'videos#fetch_by_series'
  post '/api/v1/videos/add', to: 'videos#add'

end
