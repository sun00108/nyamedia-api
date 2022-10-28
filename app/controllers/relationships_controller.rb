class RelationshipsController < ApplicationController

  def relationship_params
    params.require(:relationship).permit(:staff_id, :series_id, :role)
  end

  # GET /api/v1/relationships
  def fetch_by_info
    if params[:series_id].present?
      @relationship = Relationship.where(series_id: params[:series_id])
      render json: { status: 200, relationships: @relationship }
    elsif params[:staff_id].present?
      @relationship = Relationship.where(staff_id: params[:staff_id]).as_json
      @relationship.each do | relationship |
        series = Series.find(relationship['series_id'])
        relationship['series_name'] = series.name
        relationship['series_name_cn'] = series.name_cn
        relationship['series_season'] = series.season
        relationship['series_year'] = series.year
      end
      render json: { status: 200, relationships: @relationship }
    else
      render json: { status: 400, message: "Invalid request." }
    end
  end

  # POST /api/v1/relationships/add
  def add
    @relationship = Relationship.new(relationship_params)
    if @relationship.save
      render json: { status: 200, message: "Relationship successfully added." }
    else
      render json: @relationship.errors, status: :unprocessable_entity
    end
  end

end
