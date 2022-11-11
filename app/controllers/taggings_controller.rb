class TaggingsController < ApplicationController

  def tagging_params
    params.require(:tagging).permit(:tag_id, :series_id, :weight)
  end

  # POST /api/v1/taggings/add
  def add
    @tagging = Tagging.new(tagging_params)
    if @tagging.save
      render json: { status: 200, message: "Tagging successfully added." }
    else
      render json: @tagging.errors, status: :unprocessable_entity
    end
  end

  # POST /api/v1/taggings/update
  def update
    @taggings_new = params[:taggings]
    @taggings_old = Tagging.where(series_id: params[:series_id])
    @taggings_old.each do |tagging_old|
      unless tagging_old.tag_id.in?(@taggings_new)
        tagging_old.destroy
      end
    end
    @taggings_new.each do |tagging|
      tagging_find = Tagging.find_by(tag_id: tagging, series_id: params[:series_id])
      if tagging_find.nil?
        tagging = Tagging.new(tag_id: tagging, series_id: params[:series_id])
        tagging.save
      end
    end
  end

  # GET /api/v1/taggings/:series_id
  def fetch_by_series
    @taggings = Tagging.where(series_id: params[:series_id])
    render json: @taggings
  end

  # GET /api/v1/taggings/:tag_id
  def fetch_by_tag
    @taggings = Tagging.where(tag_id: params[:tag_id])
    render json: @taggings
  end

end
