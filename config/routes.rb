Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/api/v1/series', to: 'series#index'
  get '/api/v1/series/latest', to: 'series#fetch_latest_update'
  get '/api/v1/series/:id', to: 'series#info'
  get '/api/v1/series/:id/name', to: 'series#fetch_name'
  post '/api/v1/series/add', to: 'series#add'
  post '/api/v1/series/:id/edit', to: 'series#edit'
  post '/api/v1/series/:id/delete', to: 'series#delete'
  post '/api/v1/series/:id/sync/tagging', to: 'series#sync_tagging'

  post '/dev/api/v1/series/sync/tmdb', to: 'series#sync_nfo_tmdb'
  post '/dev/api/v1/series/sync/bgm', to: 'series#sync_nfo_bgm'

  get '/api/v1/videos', to: 'videos#index'
  get '/api/v1/videos/:id', to: 'videos#info'
  get '/api/v1/videos/series/:series_id', to: 'videos#fetch_by_series'
  post '/api/v1/videos/add', to: 'videos#add'

  post '/api/v1/wishes/add', to: 'wishes#add'

  get '/api/v1/staffs', to: 'staffs#index'
  get '/api/v1/staffs/:id', to: 'staffs#info'
  post '/api/v1/staffs/add', to: 'staffs#add'

  get '/api/v1/relationships', to: 'relationships#fetch_by_info'
  post '/api/v1/relationships/add', to: 'relationships#add'

  get '/api/v1/onairseries', to: 'onairseries#index'
  get '/api/v1/onairseries/today', to: 'onairseries#today'
  get '/api/v1/onairseries/:id', to: 'onairseries#info'
  post '/api/v1/onairseries/add', to: 'onairseries#add'
  post '/api/v1/onairseries/:id/edit', to: 'onairseries#edit'

  post '/api/v1/subtitles/add', to: 'subtitles#add'

  get '/api/v1/tags', to: 'tags#index'
  post '/api/v1/tags/add', to: 'tags#add'

  get '/api/v1/taggings/match', to: 'taggings#series_tagging_match'
  get '/api/v1/taggings/:series_id', to: 'taggings#fetch_by_series'
  post '/api/v1/taggings/update', to: 'taggings#update'

  get '/api/v1/streams/', to: 'streams#index'
  get '/api/v1/streams/:id', to: 'streams#info'
  post '/api/v1/streams/add', to: 'streams#add'

  get '/api/v1/movies', to: 'movies#index'
  get '/api/v1/movies/:id', to: 'movies#info'
  post '/api/v1/movies/add', to: 'movies#add'

  get '/api/v1/subscriptions', to: 'subscriptions#index'
  get '/api/v1/subscriptions/active', to: 'subscriptions#index_active'
  post '/api/v1/subscriptions/add', to: 'subscriptions#add'
  post '/api/v1/subscriptions/:id/deactivate', to: 'subscriptions#deactivate'

end
