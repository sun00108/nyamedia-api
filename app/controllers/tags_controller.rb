class TagsController < ApplicationController

  def tag_params
    params.require(:tag).permit(:name, :hidden)
  end

  # POST /api/v1/tags/add
  def add
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: { status: 200, message: "Tag successfully added." }
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # GET /api/v1/tags
  def index
    @tags = Tag.all
    render json: @tags
  end

end
