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

  # GET /api/v1/taggings/match
  def series_tagging_match
    series_id = params[:series_id]
    tagging_series = Tagging.where(series_id: series_id).sort_by(&:weight).reverse
    # 记录三种权重的所有标签关系
    tagging_first = Tagging.where(tag_id: tagging_series[0].tag_id).where.not(series_id: series_id)

    if tagging_series.length > 1
      tagging_second = Tagging.where(tag_id: tagging_series[1].tag_id).where.not(series_id: series_id).sort_by(&:weight).reverse.first(tagging_first.length/2+1)
    else
      tagging_second = []
    end

    if tagging_series.length > 2
      tagging_third = Tagging.where(tag_id: tagging_series[2].tag_id).where.not(series_id: series_id).sort_by(&:weight).reverse.first(tagging_first.length/4+1)
    else
      tagging_third = []
    end

    # 三种标签关系去重
    tagging_all = (tagging_first + tagging_second + tagging_third).uniq(&:series_id).as_json
    puts tagging_all.to_s
    # 主 series [标签关系] 中的 所有标签ID
    tagging_series_map = tagging_series.map { |tagging| tagging["tag_id"] }
    # 对于所有标签关系去重后的数据，对于每一个标签关系的 series_id 计算其匹配分数（weight)
    tagging_all.each do |tagging|
      tagging_score = 0
      tagging_matching = Tagging.where(series_id: tagging["series_id"])
      tagging_matching.each do |tagging_match|
        if tagging_series_map.include?(tagging_match.tag_id)
          tagging_score += tagging["weight"]
        end
      end
      tagging["score"] = tagging_score
    end
    # 对于所有标签关系相似的数据，根据其匹配分数排序，取前 n 个 series_id
    tagging_match_result = tagging_all.sort_by { |tagging_all_single| tagging_all_single["score"].to_i }.reverse.first(10)
    tagging_match_result.each do |tagging_match_result_single|
      tagging_match_result_single.delete("id")
      tagging_match_result_single.delete("created_at")
      tagging_match_result_single.delete("updated_at")
      tagging_match_result_single.delete("tag_id")
      tagging_match_result_single.delete("weight")
      series_new = Series.select(:name, :name_cn, :season).find(tagging_match_result_single["series_id"])
      tagging_match_result_single["series_name"] = series_new.name
      tagging_match_result_single["series_name_cn"] = series_new.name_cn
      tagging_match_result_single["series_season"] = series_new.season
    end
    render json: { code: 200, message: "Series tagging match successfully.", data: tagging_match_result }
  end

end
