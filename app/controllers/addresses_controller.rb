# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :set_address, only: %i[edit update destroy]

  def new
    @address = Address.new
    @address.label = 'Casa' if Current.user.addresses.none?
  end

  def create
    @address = Address.new(address_params)
    @address.user = Current.user

    respond_to do |format|
      if @address.save
        path = Current.user.addresses.count > 1 ? interest_zones_path : plans_path
        format.html do
          flash[:notice] = 'Endereço cadastrado com sucesso'
          redirect_to path
        end
        format.turbo_stream { flash.now[:notice] = 'Endereço cadastrado com sucesso' }
      else
        format.html { render :new, status: :unprocessable_content }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(helpers.dom_id(@address, :form), partial: 'addresses/form', locals: { address: @address }),
                 status: :unprocessable_content
        end
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html do
          flash[:notice] = 'Endereço atualizado com sucesso.'
          redirect_to interest_zones_path
        end
        format.turbo_stream { flash.now[:notice] = 'Endereço atualizado com sucesso.' }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(helpers.dom_id(@address, :form), partial: 'addresses/form', locals: { address: @address }),
                 status: :unprocessable_content
        end
      end
    end
  end

  def destroy
    @address.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = 'Zona de interesse removida com sucesso.'
        redirect_to interest_zones_path
      end
      format.turbo_stream { flash.now[:notice] = 'Zona de interesse removida com sucesso.' }
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
