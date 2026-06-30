# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :set_address, only: %i[edit update destroy]
  layout :resolve_layout

  def new
    @address = Address.new
    @address.label = 'Casa' if Current.user.addresses.none?
  end

  def create
    @address = Address.new(address_params)
    @address.user = Current.user

    respond_to do |format|
      if @address.save
        handle_create_success(format)
      else
        handle_create_failure(format)
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @address.update(address_params)
        handle_update_success(format)
      else
        handle_update_failure(format)
      end
    end
  end

  def destroy
    @address.destroy
    flash.now[:notice] = 'Zona de interesse removida com sucesso.'
    respond_to do |format|
      format.html { redirect_to interest_zones_path, notice: flash.now[:notice] }
      format.turbo_stream
    end
  end

  def reverse_geocode
    result = Geocoder.search([params[:lat], params[:lng]], language: 'pt-BR').first

    if result
      render json: { address: format_geocoded_address(result) }
    else
      render json: { address: 'Localização desconhecida' }, status: :not_found
    end
  end

  private

  def resolve_layout
    if action_name.in?(%w[new create]) && Current.user.addresses.none?
      'application'
    else
      'logged_in'
    end
  end

  def handle_create_success(format)
    path = Current.user.addresses.count > 1 ? interest_zones_path : home_path
    flash.now[:notice] = 'Endereço cadastrado com sucesso'
    format.html { redirect_to path, notice: flash.now[:notice] }
    format.turbo_stream
  end

  def handle_create_failure(format)
    handle_failure(format, :new)
  end

  def handle_update_success(format)
    flash.now[:notice] = 'Endereço atualizado com sucesso.'
    format.html { redirect_to interest_zones_path, notice: flash.now[:notice] }
    format.turbo_stream
  end

  def handle_update_failure(format)
    handle_failure(format, :edit)
  end

  def handle_failure(format, action)
    format.html { render action, status: :unprocessable_content }
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(helpers.dom_id(@address, :form),
                                                partial: 'addresses/form',
                                                locals: { address: @address }),
             status: :unprocessable_content
    end
  end

  def set_address
    @address = Current.user.addresses.find(params[:id])
  end

  def format_geocoded_address(result)
    components = result.data['address_components'] || []
    street = find_component(components, %w[route street_address])
    neighborhood = find_component(components, %w[sublocality sublocality_level_1 neighborhood])
    city = find_component(components, %w[administrative_area_level_2 locality])

    if street && neighborhood
      "#{street}, #{neighborhood}"
    elsif street && city
      "#{street}, #{city}"
    else
      result.address.to_s.split(',').first(2).map(&:strip).join(', ')
    end
  end

  def find_component(components, types)
    components.find { |c| c['types'].intersect?(types) }&.dig('long_name')
  end

  def address_params
    params.require(:address).permit(:cep, :uf, :address, :number, :complement, :city, :state, :label)
  end
end
