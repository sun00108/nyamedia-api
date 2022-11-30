class MoviesController < ApplicationController

  require 'net/https'
  require 'open-uri'
  require "themoviedb"
  require 'aws-sdk'
  require 'digest'

  Tmdb::Api.key(ENV['TMDB_API_KEY'])

  Aws.config.update(
    endpoint: ENV['MINIO_API_HOST'],
    access_key_id: ENV['MINIO_API_ACCESS_KEY'],
    secret_access_key: ENV['MINIO_API_SECRET_KEY'],
    force_path_style: true,
    region: 'us-east-1'
  )

  def movie_params
    params.require(:movie).permit(:name, :name_cn, :description, :tmdb_id, :bgm_id)
  end

  # GET /api/v1/movies
  def index
    @movies = Movie.all.as_json
    @movies.each do | movie |
      image = Image.find_by(id: movie['poster_id'])
      movie['poster'] = image.present? ? image.image_hash : nil
    end
    render json: { movies: @movies }
  end

  # GET /api/v1/movies/:id
  def info
    @movie = Movie.find(params[:id])
    @video = Video.where(movie_id: @movie.id)
    render json: { movie: @movie, video: @video }
  end

  # POST /api/v1/movies/add
  def add
    rubys3_client = Aws::S3::Client.new
    Tmdb::Api.language(nil)
    @movie = Movie.new(movie_params)
    bgm_url = URI('https://api.bgm.tv/subject/' + @movie.bgm_id.to_s)
    http = Net::HTTP.new(bgm_url.host, bgm_url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    header = { 'User-Agent': 'sun00108/nyamedia-nfo-sync' }
    response = http.get(bgm_url, header)
    if response.code == '200'
      if JSON.parse(response.body)['code'].present?
        header = { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 'cookie': ENV['BGM_TV_COOKIE'] }
        response = http.get(bgm_url, header)
      end
      if JSON.parse(response.body)['code'] == 404
        render json: { status: 400, message: "BGM.TV API error. (subject not found) " }
        @movie.destroy
        return
      end
      if @movie.save
        image_url = JSON.parse(response.body)['images']['large']
        image_hash = Digest::MD5.hexdigest(image_url)
        rubys3_client.put_object(
          bucket: 'nyamedia',
          key: 'movies/' + @movie.id.to_s + '/poster/' + image_hash + '.jpg',
          body: URI.open(image_url)
        )
        poster = Image.create(movie_id: @movie.id, category: 1, image_hash: image_hash)
        @movie.update(poster_id: poster.id)
      else
        render json: { status: 400, message: "BGM.TV API error." }
        @movie.destroy
        return
      end
      render json: { status: 200, message: "Movie successfully added." }
    else
      render json: { status: 400, message: @movie.errors }
    end
  end

end
