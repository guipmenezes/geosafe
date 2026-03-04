# frozen_string_literal: true

class AlertVotesController < ApplicationController
  before_action :set_alert

  def create
    @vote = @alert.alert_votes.find_or_initialize_by(user: Current.user)

    if @vote.vote_type == params[:vote_type]
      @vote.destroy
    else
      @vote.update(vote_type: params[:vote_type])
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: home_path }
    end
  end

  private

  def set_alert
    @alert = Alert.find(params[:alert_id])
  end
end
