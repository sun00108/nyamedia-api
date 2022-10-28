class WishesController < ApplicationController

  def wish_params
    params.require(:wish).permit(:bgm_id, :bgm_name)
  end

  # POST /api/v1/wishes/add
  def add
    # 需要加入验证防止恶意添加
    @wishes = Wish.where(bgm_id: params[:bgm_id])
    @wishes.each do | wish |
      if wish.bgm_user == params[:bgm_user]
        render json: { status: 400, message: "This user has already added this series." }
        return
      end
    end
    @wish_new = Wish.new(wish_params)
    if @wish_new.save
      render json: { status: 200, message: "Wish successfully added." }
    else
      render json: @wish_new.errors, status: :unprocessable_entity
    end
  end

end
