# frozen_string_literal: true

class AddressesController < ApplicationController
  def new; end

  def create
    @address = Address.new(address_params)
    @address.user = Current.user

    if @address.save
      redirect_to plans_path, notice: 'Endereço cadastrado com sucesso'
    else
      render :new, status: :unprocessable_content
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
    params.require(:address).permit(:cep, :uf, :address, :number, :complement, :city, :state)
  end
end
