class StreamsController < ApplicationController

  def stream_params
    params.require(:stream).permit(:name, :link)
  end

  # GET /api/v1/streams
  def index
    @streams = Stream.all
    render json: @streams
  end

  # GET /api/v1/streams/:id
  def info
    @stream = Stream.find(params[:id])
    render json: @stream
  end

  # POST /api/v1/streams/add
  def add
    @stream = Stream.new(stream_params)
    if @stream.save
      render json: { status: 200, message: "Stream successfully added." }
    else
      render json: @stream.errors, status: :unprocessable_entity
    end
  end

end
