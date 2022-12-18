class SubscriptionsController < ApplicationController

  def subscription_params
    params.require(:subscription).permit(:series_id, :rss_link, :active)
  end

  # GET /api/v1/subscriptions
  def index
    @subscriptions = Subscription.all
    render json: { code: 0, message: "", data: @subscriptions }
  end

  # GET /api/v1/subscriptions/active
  def index_active
    @subscriptions = Subscription.where(active: true)
    render json: { code: 0, message: "", data: @subscriptions }
  end

  # POST /api/v1/subscriptions/add
  def add
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      render json: { code: 0, message: "Subscription successfully added." }
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  # POST /api/v1/subscriptions/:id/deactivate
  def deactivate
    @subscription = Subscription.find(params[:id])
    @subscription.update(active: false)
    render json: { code: 0, message: "Subscription successfully deactivated." }
  end

end
