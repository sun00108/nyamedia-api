class OnairseriesController < ApplicationController

  def onairseries_params
    params.require(:onairseries).permit(:series_id, :day, :time, :status)
  end

  # GET /api/v1/onairseries
  def index
    @onairseries = Onairseries.all
    render json: { status: 200, onairseries: @onairseries }
  end

  # GET /api/v1/onairseries/:id
  def info
    @onairseries = Onairseries.find(params[:id])
    render json: { status: 200, onairseries: @onairseries }
  end

  # POST /api/v1/onairseries/add
  def add
    # ！后期需增加重复性检查
    @onairseries = Onairseries.new(onairseries_params)
    if @onairseries.save
      render json: { status: 200, message: "Onairseries successfully added." }
    else
      render json: @onairseries.errors, status: :unprocessable_entity
    end
  end

  # POST /api/v1/onairseries/:id/edit
  def edit
    @onairseries = Onairseries.find(params[:id])
    if @onairseries.update(onairseries_params)
      render json: @onairseries
    else
      render json: @onairseries.errors, status: :unprocessable_entity
    end
  end

  # GET /api/v1/onairseries/today
  def today
    today_integer = Date.today.cwday
    @onairseries = Onairseries.where(day: today_integer).sort_by(&:time).as_json
    @onairseries.each do | onairseries |
      series = Series.find(onairseries['series_id'])
      onairseries['series_name'] = series.name
      onairseries['series_name_cn'] = series.name_cn
      onairseries['series_season'] = series.season
      onairseries['series_year'] = series.year
      onairseries['series_poster'] = Image.find(series.poster_id).image_hash
    end
    render json: { status: 200, onairseries: @onairseries }
  end

end
