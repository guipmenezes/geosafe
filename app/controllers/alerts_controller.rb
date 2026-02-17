# frozen_string_literal: true

class AlertsController < ApplicationController
  def new
    @alert = Alert.new
  end

  def create
    @alert = Current.user.alerts.new(alert_params)

    respond_to do |format|
      if @alert.save
        format.html { redirect_to home_path, notice: 'Alerta criado com sucesso.' }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('alert_form', partial: 'alerts/form', locals: { alert: @alert }) }
      end
    end
  end

  def show
    @alert = Alert.find(params[:id])
  end

  private

  def alert_params
    params.require(:alert).permit(:alert, :location, :alert_type, :title, :description)
  end
end
