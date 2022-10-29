class StaffsController < ApplicationController

  def staff_params
    params.require(:staff).permit(:name, :name_cn)
  end

  # GET /api/v1/staffs
  def index
    @staffs = Staff.all
    render json: { status: 200, staffs: @staffs }
  end

  # GET /api/v1/staffs/:id
  def info
    @staff = Staff.find(params[:id])
    render json: { status: 200, staff: @staff }
  end

  # POST /api/v1/staffs/add
  def add
    # ！后期需增加重复性检查
    @staff = Staff.new(staff_params)
    if @staff.save
      render json: { status: 200, message: "Staff successfully added." }
    else
      render json: @staff.errors, status: :unprocessable_entity
    end
  end

end
