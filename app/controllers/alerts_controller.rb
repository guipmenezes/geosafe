# frozen_string_literal: true

class AlertsController < ApplicationController
  before_action :set_alert, only: %i[show edit update]

  def new
    @alert = Alert.new
  end

  def create
    @alert = Current.user.alerts.new(alert_params)

    respond_to do |format|
      if @alert.save
        handle_save_success(format)
      else
        handle_save_failure(format)
      end
    end
  end

  def show; end

  def edit
    authorize @alert

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    authorize @alert

    respond_to do |format|
      if @alert.update(alert_params)
        format.html { redirect_to home_path, notice: 'Alerta atualizado com sucesso.' }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(helpers.dom_id(@alert, :form), partial: 'alerts/form', locals: { alert: @alert }),
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def handle_save_success(format)
    format.html { redirect_to home_path, notice: 'Alerta criado com sucesso.' }
    format.turbo_stream
  end

  def handle_save_failure(format)
    format.html { render :new, status: :unprocessable_entity }
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(helpers.dom_id(@alert, :form), partial: 'alerts/form', locals: { alert: @alert }),
             status: :unprocessable_entity
    end
  end

  def set_alert
    @alert = Alert.find(params[:id])
  end

  def alert_params
    params.require(:alert).permit(:alert, :location, :alert_type, :title, :description, :latitude, :longitude)
  end
end
