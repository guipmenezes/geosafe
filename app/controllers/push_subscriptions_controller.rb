# frozen_string_literal: true

class PushSubscriptionsController < ApplicationController
  before_action :authenticate

  def create
    @subscription = Current.user.push_subscriptions.find_or_initialize_by(
      endpoint: push_subscription_params[:endpoint]
    )

    @subscription.assign_attributes(push_subscription_params)

    if @subscription.save
      render json: { success: true }, status: :created
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription = Current.user.push_subscriptions.find_by(endpoint: params[:id])
    @subscription&.destroy
    head :ok
  end

  private

  def push_subscription_params
    params.require(:push_subscription).permit(:endpoint, :p256dh, :auth, :user_agent)
  end
end
