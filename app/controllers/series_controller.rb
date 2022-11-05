class SeriesController < ApplicationController

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

  # GET /api/v1/series
  def index
    @series = Series.where(nsfw: 0).sort_by(&:name_cn).as_json
    @series.each do | series |
      image = Image.find_by(id: series['poster_id'])
      series['poster'] = image.present? ? image.image_hash : nil
    end
    render json: { status: 200, series: @series }
  end

  # GET /api/v1/series/:id
  def info
    @series = Series.find(params[:id])
    @episodes = Video.where(series_id: params[:id]).sort_by(&:episode).as_json
    @episodes.each do | episode |
      if episode['subtitle'].present?
        subtitle = Subtitle.select(:zh_CN_hash, :zh_TW_hash).find(episode['subtitle']).as_json
        episode['subtitle'] = subtitle
      end
    end
    @relationships = Relationship.where(series_id: params[:id]).as_json
    @relationships.each do | relationship |
      relationship['staff_name'] = Staff.find(relationship['staff_id']).name
    end
    @images = {}
    # 1: poster, 2: backdrop, 3: logo
    if @series.poster_id.present?
      @images['poster'] = Image.find(@series.poster_id).image_hash
    else
      posters = Image.where(series_id: params[:id], category: 1)
      if posters.present?
        @images['poster'] = posters.first.image_hash
      else
        @images['poster'] = nil
      end
    end
    if @series.backdrop_id.present?
      @images['backdrop'] = Image.find(@series.backdrop_id).image_hash
    else
      backdrops = Image.where(series_id: params[:id], category: 2)
      if backdrops.present?
        @images['backdrop'] = backdrops.first.image_hash
      else
        @images['backdrop'] = nil
      end
    end
    if @series.logo_id.present?
      @images['logo'] = Image.find(@series.logo_id).image_hash
    else
      logos = Image.where(series_id: params[:id], category: 3)
      if logos.present?
        @images['logo'] = logos.first.image_hash
      else
        @images['logo'] = nil
      end
    end
    render json: { status: 200, series: @series, relationships: @relationships, episodes: @episodes, images: @images }
  end

  # GET /api/v1/series/:id/name
  def fetch_name
    @series = Series.find(params[:id])
    render json: { status: 200, name: @series.name }
  end

  def series_params
    params.require(:series).permit(:name, :name_cn, :description, :tmdb_id, :bgm_id, :year, :season, :status, :poster_id, :backdrop_id, :logo_id, :nsfw)
  end

  # POST /api/v1/series/add
  def add
    @series = Series.new(series_params)
    if @series.save
      render json: @series
    else
      render json: @series.errors, status: :unprocessable_entity
    end
  end

  # POST /dev/api/v1/series/sync/tmdb
  def sync_nfo_tmdb
    language = params[:language].present? ? params[:language] : nil
    Tmdb::Api.language(language)
    rubys3_client = Aws::S3::Client.new
    series = Series.find_by(id: params[:series_id])
    if series.tmdb_id.nil?
      render json: { status: 400, message: "Series TMDB ID is not set" }
      return
    end
    images = Tmdb::TV.images(series.tmdb_id)
    images['backdrops'].each do | backdrop |
      image_url = "https://image.tmdb.org/t/p/original" + backdrop['file_path']
      image_hash = Digest::MD5.hexdigest(image_url)
      rubys3_client.put_object(
        bucket: 'nyamedia',
        key: 'series/' + series.id.to_s + '/backdrop/' + image_hash + '.jpg',
        body: URI.open(image_url)
      )
      Image.create(series_id: series.id, category: 2, image_hash: image_hash)
    end
    images['logos'].each do | logo |
      image_url = "https://image.tmdb.org/t/p/original" + logo['file_path']
      image_hash = Digest::MD5.hexdigest(image_url)
      rubys3_client.put_object(
        bucket: 'nyamedia',
        key: 'series/' + series.id.to_s + '/logo/' + image_hash + '.jpg',
        body: URI.open(image_url)
      )
      Image.create(series_id: series.id, category: 3, image_hash: image_hash)
    end
    render json: { status: 200, images: images }
  end

  # POST /dev/api/v1/series/sync/bgm
  def sync_nfo_bgm
    rubys3_client = Aws::S3::Client.new
    series = Series.find_by(id: params[:series_id])
    if series.bgm_id.nil?
      render json: { status: 400, message: "Series BGM ID is not set" }
      return
    end
    url = URI('https://api.bgm.tv/subject/' + series.bgm_id.to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    header = { 'User-Agent': 'sun00108/nyamedia-nfo-sync' }
    response = http.get(url, header)
    if response.code == '200'
      if JSON.parse(response.body)['code'].present?
        header = { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36', 'cookie': ENV['BGM_TV_COOKIE'] }
        response = http.get(url, header)
      end
      image_url = JSON.parse(response.body)['images']['large']
      image_hash = Digest::MD5.hexdigest(image_url)
      rubys3_client.put_object(
        bucket: 'nyamedia',
        key: 'series/' + series.id.to_s + '/poster/' + image_hash + '.jpg',
        body: URI.open(image_url)
      )
      poster = Image.create(series_id: series.id, category: 1, image_hash: image_hash)
      series.update(poster_id: poster.id)
      render json: { status: 200, message: "Series poster synced." }
    end
  end

  # POST /api/v1/series/:id/edit
  def edit
    @series = Series.find(params[:id])
    if @series.update(series_params)
      render json: @series
    else
      render json: @series.errors, status: :unprocessable_entity
    end
  end

  # POST /api/v1/series/:id/delete
  def delete
    @series = Series.find(params[:id])
    @series.destroy
    render json: { status: 200, message: "Series deleted" }
  end

  # GET /api/v1/series/latest
  def fetch_latest_update
    @series = Series.where(nsfw: 0).order(updated_at: :desc).limit(6).as_json
    @series.each do | series |
      image = Image.find_by(id: series['poster_id'])
      series['poster'] = image.present? ? image.image_hash : nil
    end
    render json: { status: 200, series: @series }
  end

end
