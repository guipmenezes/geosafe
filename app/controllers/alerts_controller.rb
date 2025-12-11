# frozen_string_literal: true

class AlertsController < ApplicationController
  def new
    @alert = Alert.new
  end

  def create
    @alert = Current.user.alerts.new(alert_params)

    if @alert.save
      redirect_to home_path, notice: 'Alerta criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def alert_params
    params.require(:alert).permit(:alert, :location, :resident)
  end
end
