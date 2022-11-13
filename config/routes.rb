Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/api/v1/series', to: 'series#index'
  get '/api/v1/series/latest', to: 'series#fetch_latest_update'
  get '/api/v1/series/:id', to: 'series#info'
  get '/api/v1/series/:id/name', to: 'series#fetch_name'
  post '/api/v1/series/add', to: 'series#add'
  post '/api/v1/series/:id/edit', to: 'series#edit'
  post '/api/v1/series/:id/delete', to: 'series#delete'

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

end
