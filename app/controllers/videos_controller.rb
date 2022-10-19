class VideosController < ApplicationController

  def video_params
    params.require(:video).permit(:name, :episode, :series_id, :video_hash)
  end

  # POST /api/v1/videos/add
  def add
    @video = Video.new(video_params)
    if @video.save
      render json: { status: 200, message: "Video successfully added." }
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  def edit
    @video = Video.find(params[:id])
    if @video.update(video_params)
      render json: @video
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  def fetch_by_series
    @videos = Video.where(series_id: params[:series_id])
    render json: @videos
  end

end
