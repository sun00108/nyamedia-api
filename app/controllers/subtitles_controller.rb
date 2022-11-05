class SubtitlesController < ApplicationController

  def subtitle_params
    params.require(:subtitle).permit(:zh_CN_hash, :zh_TW_hash)
  end

  # POST /api/v1/subtitles/add
  def add
    if params[:video_id].nil?
      render json: { status: 400, message: "Video id is required." }
      return
    end
    video = Video.find(params[:video_id])
    subtitle = Subtitle.new(subtitle_params)
    if subtitle.save
      video.update(subtitle: subtitle.id)
      render json: { status: 200, message: "Subtitle successfully added." }
    else
      render json: subtitle.errors, status: :unprocessable_entity
    end
  end

end
